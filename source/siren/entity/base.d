
module siren.entity.base;

import siren.entity.attributes;
import siren.entity.column;
import siren.util.types;

import std.array;
import std.exception;
import std.meta;
import std.range;
import std.string;
import std.typecons;
import std.variant;

abstract class Entity
{

}

/+ - Run-Time Helpers - +/

Nullable!Variant get(E : Entity, string field)(E entity)
{
    auto member = __traits(getMember, entity, field);

    return member.toNullableVariant;
}

Nullable!Variant get(E : Entity)(E entity, string field)
{
    foreach(accessible; getAccessibleFields!E)
    {
        if(accessible == field)
        {
            return get!(E, accessible)(entity);
        }
    }

    // Never reached.
    assert(0, "No return.");
}

Nullable!Variant[] get(E : Entity)(E entity, string[] fields)
{
    auto values = new Nullable!Variant[fields.length];

    foreach(index, field; fields)
    {
        values[index] = get(entity, field);
    }

    return values;
}

void set(E : Entity, string field)(E entity, Nullable!Variant value)
{
    alias member = Alias!(__traits(getMember, E, field));

    if(value.isNull)
    {
        static if(isNullAssignable!(typeof(member)))
        {
            __traits(getMember, entity, field) = null;
        }
        else static if(isNullableWrapped!(typeof(member)))
        {
            __traits(getMember, entity, field).nullify;
        }
        else
        {
            enforce(false, "Field `" ~ field ~ "` in Entity ~ `" ~ E.stringof ~ "` cannot be null.");
        }
    }
    else
    {
        static if(isNullableWrapped!(typeof(member)))
        {
            auto unpacked = value.get.coerce!(UnwrapNullable!(typeof(member)));
        }
        else
        {
            auto unpacked = value.get.coerce!(typeof(member));
        }

        __traits(getMember, entity, field) = unpacked;
    }
}

void set(E : Entity)(E entity, string field, Nullable!Variant value)
{
    foreach(accessible; getAccessibleFields!E)
    {
        if(accessible == field)
        {
            return set!(E, accessible)(entity, value);
        }
    }

    // Never reached.
    assert(0, "No return.");
}

void set(E : Entity)(E entity, string[] fields, Nullable!Variant[] values)
{
    enforce(fields.length == values.length, "Parameter count mismatch.");

    foreach(field, value; fields.lockstep(values))
    {
        set(entity, field, value);
    }
}

void set(E : Entity, TList...)(E entity, string[] fields, TList args)
{
    auto values = new Nullable!Variant[args.length];

    foreach(index, argument; args)
    {
        values[index] = argument.toNullableVariant;
    }

    set(entity, fields, values);
}
