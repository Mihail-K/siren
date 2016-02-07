
module siren.schema.column;

import siren.schema.table;

import std.exception;
import std.string;

enum ColumnType : string
{
    BigInt      = "BIGINT",
    Binary      = "BINARY",
    Blob        = "BLOB",
    Byte        = TinyInt,
    Char        = "CHAR",
    Date        = "DATE",
    DateTime    = "DATETIME",
    Decimal     = "DECIMAL",
    Double      = "DOUBLE",
    Float       = "FLOAT",
    Int         = "INT",
    Long        = BigInt,
    LongBlob    = "LONGBLOB",
    LongText    = "LONGTEXT",
    MediumBlob  = "MEDIUMBLOB",
    MediumInt   = "MEDIUMINT",
    MediumText  = "MEDIUMTEXT",
    Short       = SmallInt,
    SmallInt    = "SMALLINT",
    String      = VarChar,
    Text        = "TEXT",
    Time        = "TIME",
    TimeStamp   = "TIMESTAMP",
    TinyBlob    = "TINYBLOB",
    TinyInt     = "TINYINT",
    TinyText    = "TINYTEXT",
    VarBinary   = "VARBINARY",
    VarChar     = "VARCHAR",
    Year        = "YEAR"
}

@property
ColumnType toColumnType(string name)
{
    foreach(member; __traits(allMembers, ColumnType))
    {
        if(name.toUpper == member.toUpper)
        {
            return __traits(getMember, ColumnType, member);
        }
    }

    assert(0, "No Column Type `" ~ name ~ "`.");
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
    ColumnType _type;

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

    @property
    bool nullable()
    {
        return _nullable;
    }

    @property
    shared(SchemaColumn) nullable(bool nullable)
    {
        return _nullable = nullable, this;
    }

    @property
    bool primary()
    {
        return _primary;
    }

    @property
    shared(SchemaColumn) primary(bool primary)
    {
        return _primary = primary, this;
    }

    @property
    ColumnType type()
    {
        return _type;
    }

    @property
    shared(SchemaColumn) type(ColumnType type)
    {
        return _type = type, this;
    }

    @property
    shared(SchemaColumn) type(string type)
    {
        return _type.toColumnType, this;
    }

    @property
    bool unsigned()
    {
        return _unsigned;
    }

    @property
    shared(SchemaColumn) unsigned(bool unsigned)
    {
        return _unsigned = unsigned, this;
    }

    @property
    bool zerofill()
    {
        return _zerofill;
    }

    @property
    shared(SchemaColumn) zerofill(bool zerofill)
    {
        return _zerofill = zerofill, this;
    }
}
