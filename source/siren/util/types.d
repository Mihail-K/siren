
module siren.util.types;

import std.traits;
import std.typecons;
import std.variant;

template isNullAssignable(T)
{
    enum isNullAssignable = isAssignable!(T, typeof(null));
}

template isNullableWrapped(T)
{
    static if(__traits(compiles, TemplateOf!T))
    {
        enum isNullableWrapped = __traits(isSame, Nullable, TemplateOf!T);
    }
    else
    {
        enum isNullableWrapped = false;
    }
}

@property
Nullable!Variant toNullableVariant(T)(T value)
{
    Nullable!Variant nv;

    static if(isNullAssignable!(T))
    {
        if(value !is null)
        {
            nv = Variant(value);
        }
    }
    else static if(isNullableWrapped!(T))
    {
        if(!value.isNull)
        {
            nv = Variant(value.get);
        }
    }
    else static if(is(T == struct))
    {
        T *ptr = new T;
        *ptr = value;

        nv = Variant(ptr);
    }
    else
    {
        nv = Variant(value);
    }

    return nv;
}

@property
T fromNullableVariant(T)(Nullable!Variant value)
{
    if(value.isNull)
    {
        return T.init;
    }
    else
    {
        static if(isNullAssignable!T)
        {
            return value.get.get!T;
        }
        else static if(isNullableWrapped!T)
        {
            T result = value.get.get!(UnwrapNullable!T);
            return result;
        }
        else static if(is(T == struct))
        {
            T *ptr = value.get.get!(T *);
            return *ptr;
        }
        else
        {
            return value.get.get!T;
        }
    }
}

template UnwrapNullable(T)
if(isNullableWrapped!T)
{
    alias UnwrapNullable = TemplateArgsOf!T[0];
}

alias Bool   = Nullable!bool;
alias Char   = Nullable!char;
alias Byte   = Nullable!byte;
alias UByte  = Nullable!ubyte;
alias Short  = Nullable!short;
alias UShort = Nullable!ushort;
alias Int    = Nullable!int;
alias UInt   = Nullable!uint;
alias Long   = Nullable!long;
alias ULong  = Nullable!ulong;
alias Float  = Nullable!float;
alias Double = Nullable!double;
