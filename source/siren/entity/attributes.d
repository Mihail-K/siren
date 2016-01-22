
module siren.entity.attributes;

import siren.entity.base;

import std.algorithm;
import std.meta;
import std.traits;

template isAccessible(E : Entity)
{
    enum isAccessible = __traits(getProtection, E) == "public";
}

template isAccessible(E : Entity, string member)
{
    static if(isAccessible!E && __traits(hasMember, E, member))
    {
        enum isAccessible = __traits(getProtection, __traits(getMember, E, member)) == "public";
    }
    else
    {
        enum isAccessible = false;
    }
}

template isAccessibleField(E : Entity, string field)
{
    static if(isAccessible!(E, field))
    {
        enum isAccessibleField = [ FieldNameTuple!E ].countUntil(field) != -1;
    }
    else
    {
        enum isAccessibleField = false;
    }
}

template isAccessibleFunction(E : Entity, string name)
{
    static if(isAccessible!(E, name))
    {
        enum isAccessibleFunction = typeof(__traits(getMember, E, name) == function);
    }
    else
    {
        enum isAccessibleFunction = false;
    }
}

template getAccessibleFields(E : Entity)
{
    template _isAccessibleField(string field)
    {
        enum _isAccessibleField = isAccessibleField!(E, field);
    }

    alias getAccessibleFields = Filter!(_isAccessibleField, FieldNameTuple!E);
}

template getAccessibleFunctions(E : Entity)
{
    template _isAccessibleFunction(string name)
    {
        enum _isAccessibleFunction = isAccessibleFunction!(E, name);
    }

    alias getAccessibleFunctions = Filter!(_isAccessibleFunction, __traits(allMembers, E));
}
