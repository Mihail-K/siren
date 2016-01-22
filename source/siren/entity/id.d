
module siren.entity.id;

import siren.entity.attributes;
import siren.entity.base;
import siren.entity.column;

import std.meta;
import std.traits;

struct ID
{
}

template isID(M : Model, string field)
{
    static if(isAccessibleField!(M, field))
    {
        enum isID = hasUDA!(__traits(getMember, M, field), ID);
    }
    else
    {
        enum isID = false;
    }
}

template hasID(M : Model)
{
    template _isID(string field)
    {
        enum _isID = isID!(M, field);
    }

    enum hasID = Filter!(_isID, FieldNameTuple!M).length > 0;
}

template getIDColumn(M : Model)
{
    enum getIDColumn = getColumn!(M, getIDColumnField!M);
}

template getIDColumnName(M : Model)
{
    enum getIDColumnName = getIDColumn!M.name;
}

template getIDColumnField(M : Model)
{
    static assert(hasID!M, "Model `" ~ M.stringof ~ "` doesn't have an ID.");

    template _isID(string field)
    {
        enum _isID = isID!(M, field);
    }

    alias idColumns = Filter!(_isID, FieldNameTuple!M);
    static assert(idColumns.length == 1, "Model `" ~ M.stringof ~ "` defines multiple IDs.");

    enum getIDColumnField = idColumns[0];
}

template IDType(M : Model)
{
    static assert(hasID!M, "Model `" ~ M.stringof ~ "` doesn't have an ID.");

    alias IDType = typeof(__traits(getMember, M, getIDColumnField!M));
}
