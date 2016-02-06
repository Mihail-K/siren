
module siren.schema.column;

import siren.schema.table;

import std.exception;

final shared class SchemaColumn
{
private:
    string _name;
    SchemaTable _table;
    string _type;

package:
    this(string name, shared SchemaTable table)
    {
        _name = name;
        _table = table;
    }

public:
    @property
    shared(SchemaTable) end()
    {
        enforce(_type.length > 0, "Column `" ~ _name ~ "` in table `" ~ _table.name ~ "` has no type.");

        return _table;
    }

    @property
    string name()
    {
        return _name;
    }

    shared(SchemaColumn) type(string type)
    {
        _type = type;

        return this;
    }
}
