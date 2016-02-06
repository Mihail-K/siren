
module siren.schema.column;

import siren.schema.table;

import std.exception;

final shared class SchemaColumn
{
private:
    bool _nullable = true;
    bool _primary  = false;
    bool _zerofill = false;

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

    shared(SchemaColumn) nullable(bool nullable = true)
    {
        _nullable = nullable;

        return this;
    }

    shared(SchemaColumn) primary(bool primary = true)
    {
        _primary = primary;

        return this;
    }

    shared(SchemaColumn) type(string type)
    {
        _type = type;

        return this;
    }

    shared(SchemaColumn) zerofill(bool zerofill = true)
    {
        _zerofill = zerofill;

        return this;
    }
}
