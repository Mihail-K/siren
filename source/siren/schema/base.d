
module siren.schema.base;

import siren.schema.table;

import std.exception;

mixin template Schema(SchemaBuilder function(SchemaBuilder) callback)
{
    enum SchemaDefinition schemaDefinition = {
        auto builder = new SchemaBuilder;
        callback(builder);
        return builder.build;
    }();
}

struct SchemaDefinition
{
private:
    TableDefinition[string] _tables;

public:
    @property
    const(TableDefinition)[] tables() const
    {
        return _tables.values;
    }

    @property
    size_t length() const
    {
        return _tables.length;
    }

    bool opBinaryRight(string op : "in")(string table)
    {
        return !!(table in _tables);
    }

    TableDefinition opIndex(string table)
    {
        auto ptr = table in _tables;
        assert(ptr, "No table `" ~ table ~ "` in schema.");

        return *ptr;
    }
}

class SchemaBuilder
{
package:
    TableBuilder[string] _tables;

public:
    SchemaDefinition build()
    {
        TableDefinition[string] tables;

        foreach(name, table; _tables)
        {
            tables[name] = table.build;
        }

        return SchemaDefinition(tables);
    }

    TableBuilder table(string name)
    {
        enforce(name !in _tables, "Duplicate table `" ~ name ~ "`.");

        return _tables[name] = new TableBuilder(name, this);
    }

    SchemaBuilder end()
    {
        return this;
    }
}
