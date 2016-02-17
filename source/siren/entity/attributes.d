
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
