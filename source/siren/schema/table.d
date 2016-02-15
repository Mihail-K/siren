
module siren.schema.table;

import siren.schema.base;
import siren.schema.column;

import std.algorithm;
import std.conv;
import std.exception;
import std.meta;

struct TableDefinition
{
private:
    ColumnDefinition[string] _columns;
    string _name;

public:
    @property
    const(ColumnDefinition)[] columns() const
    {
        return _columns.values;
    }

    @property
    size_t length() const
    {
        return _columns.length;
    }

    @property
    string name() const
    {
        return _name;
    }

    bool opBinaryRight(string op : "in")(string column)
    {
        return !!(column in _columns);
    }

    ColumnDefinition opIndex(string column)
    {
        return _columns[column];
    }
}

template tableColumns(TableDefinition table)
{
    mixin("alias tableColumns = AliasSeq!(" ~ table.columns.text[1 .. $ - 1] ~ ");");
}

template tableColumnNames(TableDefinition table)
{
    template _getName(ColumnDefinition column)
    {
        enum _getName = column.name;
    }

    alias tableColumnNames = staticMap!(_getName, tableColumns!table);
}

template hasPrimary(TableDefinition table)
{
    template _isPrimary(ColumnDefinition column)
    {
        enum _isPrimary = column.primary;
    }

    enum hasPrimary = Filter!(_isPrimary, tableColumns!table).length > 0;
}

template primaryColumn(TableDefinition table)
if(hasPrimary!table)
{
    template _isPrimary(ColumnDefinition column)
    {
        enum _isPrimary = column.primary;
    }

    enum primaryColumn = Filter!(_isPrimary, tableColumns!table)[0];
}

template PrimaryType(TableDefinition table)
if(hasPrimary!table)
{
    mixin("alias PrimaryType = " ~ primaryColumn!table.dtype ~ ";");
}

class TableBuilder
{
package:
    ColumnBuilder[string] _columns;
    string _name;
    SchemaBuilder _schema;

public:
    this(string name, SchemaBuilder schema)
    {
        _name = name;
        _schema = schema;
    }

    TableDefinition build()
    {
        ColumnDefinition[string] columns;

        foreach(name, column; _columns)
        {
            columns[name] = column.build;
        }

        return TableDefinition(columns, _name);
    }

    @property
    ColumnBuilder column(string name)
    {
        enforce(name !in _columns, "Duplicate column `" ~ name ~ "` for table `" ~ _name ~ "`.");

        return _columns[name] = new ColumnBuilder(name, this);
    }

    @property
    SchemaBuilder end()
    {
        return _schema;
    }

    package bool hasPrimary()
    {
        return _columns.values.any!(c => c._primary);
    }

    @property
    TableBuilder primary(string name = "id", string type = "int")
    {
        column(name).type(type).primary(true).unsigned(true).nullable(false);

        return this;
    }

    @property
    TableBuilder table(string name)
    {
        return _schema.table(name);
    }
}
