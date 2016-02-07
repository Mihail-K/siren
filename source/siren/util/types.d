
module siren.util.types;

import std.traits;
import std.typecons;

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
