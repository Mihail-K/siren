
module siren.entity.schema;

import siren.schema;
import siren.util;

import std.array;
import std.string;

mixin template Schema()
{
    import siren.entity;
    import siren.schema;
    import siren.util;

    import std.meta;

    mixin("import " ~ typeof(this).schemaModule ~ ";");

public:
    /++
     + Accessor for the schema definition that defines this entity.
     ++/
    @property
    alias schemaDefinition = Alias!(mixin(typeof(this).schemaModule ~ ".schemaDefinition"));

    /++
     + The default table name for this entity.
     ++/
    @property
    enum string table = typeof(this).stringof.toCamelCase;

    @property
    enum bool hasPrimary = hasPrimaryColumn!(typeof(this).tableDefinition);

    // Check if the model defines a primary key.
    static if(typeof(this).hasPrimary)
    {
        /++
         + The entity's primary key defintion.
         ++/
        @property
        alias primaryKey = Alias!(primaryColumn!(typeof(this).tableDefinition));

        /++
         + The name of the entity's primary column.
         ++/
        @property
        enum string primaryKeyName = typeof(this).primaryKey.name;

        /++
         + The name of the field in the entity that maps to the primary column.
         ++/
        @property
        enum string primaryKeyField = typeof(this).primaryKeyName.toCamelCase;

        /++
         + Alias for the type of the primary column.
         ++/
        @property
        alias PrimaryKey = PrimaryType!(typeof(this).tableDefinition);
    }

    /++
     + Alias for the column defintions that are part of this entity.
     ++/
    alias columnDefintions = tableColumns!(typeof(this).tableDefinition);

    /++
     + Alias for the names of the columns that define this entity.
     ++/
    alias columnNames = tableColumnNames!(typeof(this).tableDefinition);

    /++
     + Checks if a column is present in the table definition.
     ++/
    enum hasColumn(string column) = column in typeof(this).tableDefinition;

    /++
     + Accessor for the table definition that defines this entity.
     ++/
    @property
    alias tableDefinition = Alias!(typeof(this).schemaDefinition.opIndex(typeof(this).table));
}

/+ - Compile-Time Helpers - +/

template isEntity(E)
{
    enum isEntity =
        is(typeof(__traits(getMember, E, "schemaDefinition")) == SchemaDefinition) &&
        is(typeof(__traits(getMember, E, "tableDefinition")) == TableDefinition) &&
        is(typeof(__traits(getMember, E, "table")) : string);
}
