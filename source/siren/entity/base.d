
module siren.entity.base;

import siren.entity.callback;
import siren.schema;
import siren.util;

import std.array;
import std.exception;
import std.meta;
import std.range;
import std.string;
import std.typecons;
import std.variant;

mixin template Entity(string module_ = "schema")
{
private:
    import std.algorithm;
    import std.array;
    import std.meta;
    import std.string;
    import std.typecons;
    import std.variant;

    mixin("import " ~ module_ ~ ";");

    static assert(
        __traits(hasMember, mixin(module_), "schemaDefinition"),
        "No Schema Definition in module `" ~ module_ ~ "`."
    );

    static assert(
        is(typeof(schemaDefinition) == SchemaDefinition),
        "Invalid schema definition."
    );

    static assert(
        typeof(this).table in schemaDefinition,
        "No Table `" ~ typeof(this).table ~ "` defined in Schema."
    );

private:
    static Adapter _adapter;
    static Query _query;

    // Define Fields => Columns.
    mixin(fields(tableDefinition));

public:
    // Define Properties => Fields.
    mixin(properties(tableDefinition));

    mixin GetFunctions; // get(fields)
    mixin SetFunctions; // set(fields, values)

    mixin Callbacks;
    mixin Relations;

    /++
     + Alias for the schema definition that defines this entity.
     ++/
    alias schemaDefinition = Alias!(__traits(getMember, mixin(module_), "schemaDefinition"));

    /++
     + The default table name for this entity.
     ++/
    enum table = typeof(this).stringof.toLower;

    /++
     + Alias for the table definition that defines this entity.
     ++/
    alias tableDefinition = Alias!(schemaDefinition.opIndex(typeof(this).table));

public:
    @property
    static Adapter adapter()
    {
        if(_adapter is null)
        {
            // Use lazy initialization.
            // TODO : Select adapter based on Entity.
            _adapter = AdapterProvider.get;
        }

        if(!_adapter.connected)
        {
            // Connect to DB.
            _adapter.connect;
        }

        return _adapter;
    }

    @property
    static Query query()
    {
        if(_query is null)
        {
            // Use lazy initialization.
            _query = new Query(typeof(this).table);
        }

        return _query;
    }

    /++
     + Forwards to the Entity's adapter's transaction function.
     ++/
    static void transaction(void delegate(Adapter) callback)
    {
        adapter.transaction(callback);
    }

    /++
     + Ditto.
     ++/
    static void transaction(bool nested, void delegate(Adapter) callback)
    {
        adapter.transaction(nested, callback);
    }
}

template isEntity(E)
{
    enum isEntity =
        is(typeof(__traits(getMember, E, "schemaDefinition")) == SchemaDefinition) &&
        is(typeof(__traits(getMember, E, "tableDefinition")) == TableDefinition) &&
        is(typeof(__traits(getMember, E, "table")) : string);
}

/+ - Code Generation - +/

string fields(TableDefinition table)
{
    auto buffer = appender!string;

    foreach(column; table.columns)
    {
        buffer ~= "%2$s _%1$s;\n".format(
            column.name.toCamelCase,
            column.dtype
        );
    }

    return buffer.data;
}

string properties(TableDefinition table)
{
    auto buffer = appender!string;

    foreach(column; table.columns)
    {
        buffer ~= "
        @property %2$s %1$s() { return this._%1$s; }
        @property %2$s %1$s(%2$s value) { return this._%1$s = value; }
        ".format(
            column.name.toCamelCase,
            column.dtype
        );
    }

    return buffer.data;
}

mixin template GetFunctions()
{
    Nullable!Variant[] get(string[] names)
    {
        auto values = new Nullable!Variant[names.length];

        OUTER: foreach(index, name; names)
        {
            foreach(column; tableColumns!tableDefinition)
            {
                if(name == column.name.toCamelCase)
                {
                    mixin("values[index] = this." ~ column.name.toCamelCase ~ ".toNullableVariant;");
                    continue OUTER;
                }
            }
        }

        return values;
    }
}

mixin template SetFunctions()
{
    void set(string[] names, Nullable!Variant[] values)
    {
        import std.range : lockstep;

        OUTER: foreach(name, value; names.lockstep(values))
        {
            foreach(column; tableColumns!tableDefinition)
            {
                if(name == column.name.toCamelCase)
                {
                    mixin("alias ColumnType = " ~ column.dtype ~ ";");
                    auto result = value.fromNullableVariant!ColumnType;

                    mixin("this." ~ column.name.toCamelCase ~ " = result;");
                    continue OUTER;
                }
            }
        }
    }

    void set(Nullable!Variant[string] values)
    {
        this.set(values.keys, values.values);
    }
}
