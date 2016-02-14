
module siren.entity.column;

import siren.entity.attributes;
import siren.entity.base;
import siren.entity.id;
import siren.entity.relation;
import siren.entity.transient;

import std.algorithm;
import std.array;
import std.exception;
import std.meta;
import std.string;
import std.traits;

struct Column
{
private:
    string _name;

public:
    this(string name)
    {
        _name = name;
    }

    @property
    string name()
    {
        return _name;
    }
}

/+ - Run-Time Helpers - +/

bool hasColumn(E : Entity)(string column)
{
    return [ getColumnNames!E ].countUntil(column) != -1;
}

bool hasColumn(E : Entity)(E entity, string column)
{
    return column.hasColumn!E;
}

bool hasColumnField(E : Entity)(string field)
{
    return [ getColumnFields!E ].countUntil(field) != -1;
}

bool hasColumnField(E : Entity)(E entity, string field)
{
    return field.hasColumnField!E;
}

string toColumn(E : Entity)(E entity, string field)
{
    enforce(hasColumnField(entity, field), "Entity `" ~ E.stringof ~ "` doesn't have column at `" ~ field ~ "`.");

    foreach(accessible; getColumnFields!E)
    {
        if(accessible == field)
        {
            return toColumn!(E, accessible);
        }
    }

    // Never reached.
    assert(0, "No return.");
}

string[] toColumns(E : Entity)(E entity, string[] fields)
{
    return fields.map!(field => toColumn(entity, field)).array;
}

string toField(E : Entity)(E entity, string column)
{
    enforce(hasColumn(entity, column), "Entity `" ~ E.stringof ~ "` doesn't have column `" ~ column ~ "`.");

    foreach(accessible; getColumnNames!E)
    {
        if(accessible == column)
        {
            return toField!(E, accessible);
        }
    }

    // Never reached.
    assert(0, "No return.");
}

string[] toFields(E : Entity)(E entity, string[] columns)
{
    return columns.map!(column => toField(entity, column)).array;
}

/+ - Compile-Time Helpers - +/

template isColumn(E : Entity, string field)
{
    static if(isAccessibleField!(E, field))
    {
        enum isColumn = !isTransient!(E, field) && !isRelation!(E, field);
    }
    else
    {
        enum isColumn = false;
    }
}

template getColumn(E : Entity, string field)
{
    static assert(isColumn!(E, field), "Field `" ~ field ~ "` in Entity `" ~ E.stringof ~ "` is not a column.");

    static if(getUDAs!(__traits(getMember, E, field), Column).length > 0)
    {
        enum getColumn = getUDAs!(__traits(getMember, E, field), Column)[0];
    }
    else
    {
        enum getColumn = Column(field.toLower);
    }
}

template getColumns(E : Entity)
{
    template _getColumn(string field)
    {
        enum _getColumn = getColumn!(E, field);
    }

    alias getColumns = staticMap!(_getColumn, getColumnFields!E);
}

template getColumnNames(E : Entity)
{
    template _getColumnName(Column column)
    {
        enum _getColumnName = column.name;
    }

    alias getColumnNames = staticMap!(_getColumnName, getColumns!E);
}

template getColumnField(E : Entity, string column)
{
    static assert(hasColumn!(E, column), "Entity `" ~ E.stringof ~ "` doesn't have column `" ~ column ~ "`.");

    template _isColumnField(string field)
    {
        enum _isColumnField = getColumn!(E, field).name == column;
    }

    enum getColumnField = Filter!(_isColumnField, getColumnFields!E)[0];
}

template getColumnFields(E : Entity)
{
    template _isColumn(string field)
    {
        enum _isColumn = isColumn!(E, field);
    }

    alias getColumnFields = Filter!(_isColumn, FieldNameTuple!E);
}

template getNonIDColumns(E : Entity)
{
    template _getColumn(string field)
    {
        enum _getColumn = getColumn!(E, field);
    }

    alias getNonIDColumns = staticMap!(_getColumn, getNonIDColumnFields!E);
}

template getNonIDColumnFields(E : Entity)
{
    template _isNonIDColumn(string field)
    {
        enum _isNonIDColumn = isColumn!(E, field) && !isID!(E, field);
    }

    alias getNonIDColumnFields = Filter!(_isNonIDColumn, FieldNameTuple!E);
}

template getNonIDColumnNames(E : Entity)
{
    template _getColumnName(Column column)
    {
        enum _getColumnName = column.name;
    }

    alias getNonIDColumnNames = staticMap!(_getColumnName, getNonIDColumns!E);
}

template hasColumn(E : Entity, string column)
{
    enum hasColumn = [ getColumnNames!E ].countUntil(column) != -1;
}

template hasColumnField(E : Entity, string field)
{
    enum hasColumnField = [ getColumnFields!E ].countUntil(field) != -1;
}

template toColumn(E : Entity, string field)
{
    enum toColumn = getColumn!(E, field).name;
}

template toField(E : Entity, string column)
{
    enum toField = getColumnField!(E, column);
}
