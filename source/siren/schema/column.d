
module siren.schema.column;

import siren.schema.table;

import std.exception;
import std.string;

enum ColumnType : string
{
    BIGINT     = "BIGINT",
    BLOB       = "BLOB",
    BOOLEAN    = "BOOLEAN",
    BOOL       = "BOOLEAN",
    CHAR       = "CHAR",
    DOUBLE     = "DOUBLE",
    FLOAT      = "FLOAT",
    INT        = "INT",
    STRING     = "STRING",
    TEXT       = "TEXT"
}

@property
ColumnType toColumnType(string type)
{
    foreach(name; __traits(allMembers, ColumnType))
    {
        if(type == name)
        {
            return __traits(getMember, ColumnType, name);
        }
    }

    assert(0);
}

final shared class SchemaColumn
{
private:
    bool _nullable = true;
    bool _primary  = false;
    bool _unsigned = false;
    bool _zerofill = false;

    string _name;
    SchemaTable _table;
    ColumnType _type = ColumnType.INT;

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

    shared(SchemaColumn) type(ColumnType type)
    {
        _type = type;

        return this;
    }

    shared(SchemaColumn) type(string type)
    {
        return this.type(type.toUpper.toColumnType);
    }

    shared(SchemaColumn) unsigned(bool unsigned = true)
    {
        _unsigned = unsigned;

        return this;
    }

    shared(SchemaColumn) zerofill(bool zerofill = true)
    {
        _zerofill = zerofill;

        return this;
    }
}
