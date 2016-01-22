
module siren.entity.transient;

import siren.entity.attributes;
import siren.entity.base;

import std.traits;

struct Transient
{
}

template isTransient(E : Entity, string field)
{
    static if(isAccessibleField!(E, field))
    {
        enum isTransient = hasUDA!(__traits(getMember, E, field), Transient);
    }
    else
    {
        enum isTransient = false;
    }
}
