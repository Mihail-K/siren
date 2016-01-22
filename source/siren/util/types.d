
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
