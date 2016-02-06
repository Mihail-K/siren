
module siren.schema.base;

import siren.schema.table;

import std.exception;

final shared class Schema
{
private:
    static shared Schema _instance = new shared Schema;

    SchemaTable[string] _tables;

    shared this()
    {
    }

public:
    @property
    void end()
    {
        // No-Op
    }

    @property
    static shared(Schema) start()
    {
        return _instance;
    }

    @property
    shared(SchemaTable) table(string name)
    {
        enforce(name !in _tables, "Duplicate table `" ~ name ~ "`.");

        return _tables[name] = new shared SchemaTable(name, this);
    }
}
