
module siren.entity.attributes;

import siren.schema;
import siren.util;

import std.array;
import std.string;

mixin template Attributes(string module_ = "schema")
{
    import siren.schema;
    import siren.util;

    mixin("import " ~ module_ ~ ";");

    import std.meta;
    import std.range;
    import std.typecons;
    import std.variant;

    // Ensure that a schema in present in the imported module.
    static assert(__traits(hasMember, mixin(module_), "schemaDefinition"));

    // Ensure that the imported schema is of the right type.
    static assert(is(typeof(typeof(this).schemaDefinition) == SchemaDefinition));

    // Entities need a corresponding table in the schema to map fields.
    static assert(typeof(this).table in typeof(this).schemaDefinition);

public:
    /++
     + Alias for the schema definition that defines this entity.
     ++/
    alias schemaDefinition = Alias!(__traits(getMember, mixin(module_), "schemaDefinition"));

    /++
     + The default table name for this entity.
     ++/
    enum string table = typeof(this).stringof.toCamelCase;

    // Check if the model defines a primary key.
    static if(hasPrimary!(typeof(this).tableDefinition))
    {
        /++
         + The name of the Entity's primary key in the database.
         ++/
        enum string primaryKey = primaryColumn!(typeof(this).tableDefinition).name;
    }

    /++
     + Alias for the table definition that defines this entity.
     ++/
    alias tableDefinition = Alias!(typeof(this).schemaDefinition.opIndex(typeof(this).table));

private:
    /++
     + Dynamically introduces fields corresponding to fields present in the
     + Entity's table definition.
     ++/
    mixin(fields(typeof(this).tableDefinition));

public:
    /++
     + Dynamically introduces read and write properties to fields present in
     + the Entity's table definition.
     ++/
    mixin(properties(typeof(this).tableDefinition));

    /++
     + Constructs and hydrates a new instance of the Entity, firing an
     + After-Load event, given the Entity type supports it.
     ++/
    static typeof(this) construct(string[] fields, Nullable!Variant[] values)
    {
        auto entity = new typeof(this);

        // Hydrate entity.
        entity.hydrate(fields, values);

        // Raise an event if the entity supports them.
        static if(__traits(hasMember, entity, "raise"))
        {
            entity.raise(CallbackEvent.AfterLoad);
        }

        return entity;
    }

    /++
     + Hydrates this instance of the Entity using two arrays containing fields
     + corresponding to values, and preparing any assocations on the Entity,
     + given the Entity type supports them.
     ++/
    typeof(this) hydrate(string[] names, Nullable!Variant[] values)
    {
        this.set(names, values);

        // Populate associations if the entity supports them.
        static if(__traits(hasMember, typeof(this), "prepareAssociations"))
        {
            this.prepareAssociations;
        }

        return this;
    }

    /++
     + Ditto, but takes parameters as an associative array.
     ++/
    typeof(this) hydrate(Nullable!Variant[string] values)
    {
        return this.hydrate(values.keys, values.values);
    }

    /++
     + Reads values from the Entity's mapped fields (defined in the Schema).
     ++/
    Nullable!Variant[] get(string[] names)
    {
        auto values = new Nullable!Variant[names.length];

        OUTER: foreach(index, name; names)
        {
            foreach(column; tableColumns!tableDefinition)
            {
                enum field = column.name.toCamelCase;

                if(name == field)
                {
                    mixin("values[index] = this." ~ field ~ ".toNullableVariant;");
                    continue OUTER;
                }
            }
        }

        return values;
    }

    /++
     + Writes values to the Entity's mapped fields (defined in the Schema).
     + Values are given by two arrays containing fields corresponding to values.
     ++/
    typeof(this) set(string[] names, Nullable!Variant[] values)
    {
        OUTER: foreach(name, value; names.lockstep(values))
        {
            foreach(column; tableColumns!tableDefinition)
            {
                enum field = column.name.toCamelCase;

                if(name == field)
                {
                    mixin("alias ColumnType = " ~ column.dtype ~ ";");
                    auto result = value.fromNullableVariant!ColumnType;

                    mixin("this." ~ field ~ " = result;");
                    continue OUTER;
                }
            }
        }

        return this;
    }

    /++
     + Ditto, but takes parameters as an associative array.
     ++/
    typeof(this) set(Nullable!Variant[string] values)
    {
        return this.set(values.keys, values.values);
    }
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
