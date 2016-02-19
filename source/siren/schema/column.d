
module siren.schema.column;

import siren.schema.table;

import std.exception;
import std.traits;

enum ColumnType : string
{
    BIG_INT    = "bigint",
    BINARY     = "binary",
    BLOB       = "blob",
    BOOL       = "bool",
    CHAR       = "char",
    DATE       = "date",
    DECIMAL    = "decimal",
    DOUBLE     = "double",
    FLOAT      = "float",
    INT        = "int",
    JSON       = "json",
    REAL       = "real",
    SMALL_INT  = "smallint",
    STRING     = "string",
    TEXT       = "text",
    TIME       = "time",
    TIMESTAMP  = "timestamp",
    VAR_BINARY = "varbinary",
    VAR_CHAR   = "varchar",
    XML        = "xml"
}

@property
ColumnType toColumnType(string text)
{
    foreach(columnType; EnumMembers!ColumnType)
    {
        if(text == cast(string) columnType)
        {
            return columnType;
        }
    }

    assert(0, "Unsupported type: " ~ text);
}

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
            case ColumnType.BIG_INT:
                return unsigned ? "ulong" : "long";

            case ColumnType.BLOB:
            case ColumnType.BINARY:
            case ColumnType.VAR_BINARY:
                return "ubyte[]";

            case ColumnType.BOOL:
                return "bool";

            case ColumnType.DOUBLE:
                return "double";

            case ColumnType.INT:
                return unsigned ? "uint" : "int";

            case ColumnType.CHAR:
            case ColumnType.STRING:
            case ColumnType.TEXT:
            case ColumnType.VAR_CHAR:
                return "string";

            case ColumnType.SMALL_INT:
                return unsigned ? "ushort" : "short";

            default:
                assert(0);
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
    ColumnType type() const
    {
        return cast(ColumnType) _type;
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
    ColumnType _type = ColumnType.INT;

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
        enforce(!_table.hasPrimaryColumn, "Table `" ~ _table._name ~ "` already has primary key.");

        return _primary = primary, this;
    }

    @property
    ColumnBuilder type(ColumnType type)
    {
        return _type = type, this;
    }

    @property
    ColumnBuilder type(string type)
    {
        return _type = type.toColumnType, this;
    }

    @property
    ColumnBuilder unsigned(bool unsigned)
    {
        return _unsigned = unsigned, this;
    }
}
