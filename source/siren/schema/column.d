
module siren.schema.column;

import siren.schema.table;

import std.exception;

struct ColumnDefinition
{
private:
    string _name;
    string _type;

    bool _nullable;
    bool _primary;
    bool _unsigned;

public:
    @property
    string dtype() const
    {
        switch(type)
        {
            case "int":
                return unsigned ? "uint" : "int";
            default:
                return type;
        }
    }

    @property
    string name() const
    {
        return _name;
    }

    @property
    bool nullable() const
    {
        return _nullable;
    }

    @property
    bool primary() const
    {
        return _primary;
    }

    @property
    string type() const
    {
        return _type;
    }

    @property
    bool unsigned() const
    {
        return _unsigned;
    }
}

class ColumnBuilder
{
package:
    TableBuilder _table;

    string _name;
    string _type = "int";

    bool _nullable = true;
    bool _primary  = false;
    bool _unsigned = false;

public:
    this(string name, TableBuilder table)
    {
        _name = name;
        _table = table;
    }

    ColumnDefinition build()
    {
        return ColumnDefinition(_name, _type, _nullable, _primary, _unsigned);
    }

    @property
    TableBuilder end()
    {
        return _table;
    }

    @property
    ColumnBuilder nullable(bool nullable)
    {
        return _nullable = nullable, this;
    }

    @property
    ColumnBuilder primary(bool primary)
    {
        enforce(!_table.hasPrimary, "Table `" ~ _table._name ~ "` already has primary key.");

        return _primary = primary, this;
    }

    @property
    ColumnBuilder type(string type)
    {
        return _type = type, this;
    }

    @property
    ColumnBuilder unsigned(bool unsigned)
    {
        return _unsigned = unsigned, this;
    }
}
