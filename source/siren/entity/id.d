
module siren.entity.id;

import siren.entity.attributes;
import siren.entity.base;
import siren.entity.column;

import std.meta;
import std.traits;

struct ID
{
}

template isID(E : Entity, string field)
{
    static if(isAccessibleField!(E, field))
    {
        enum isID = hasUDA!(__traits(getMember, E, field), ID);
    }
    else
    {
        enum isID = false;
    }
}

template hasID(E : Entity)
{
    template _isID(string field)
    {
        enum _isID = isID!(E, field);
    }

    enum hasID = Filter!(_isID, FieldNameTuple!E).length > 0;
}

template getIDColumn(E : Entity)
{
    enum getIDColumn = getColumn!(E, getIDColumnField!E);
}

template getIDColumnName(E : Entity)
{
    enum getIDColumnName = getIDColumn!E.name;
}

template getIDColumnField(E : Entity)
{
    static assert(hasID!E, "Entity `" ~ E.stringof ~ "` doesn't have an ID.");

    template _isID(string field)
    {
        enum _isID = isID!(E, field);
    }

    alias idColumns = Filter!(_isID, FieldNameTuple!E);
    static assert(idColumns.length == 1, "Entity `" ~ E.stringof ~ "` defines multiple IDs.");

    enum getIDColumnField = idColumns[0];
}

template IDType(E : Entity)
{
    static assert(hasID!E, "Entity `" ~ E.stringof ~ "` doesn't have an ID.");

    alias IDType = typeof(__traits(getMember, E, getIDColumnField!E));
}
