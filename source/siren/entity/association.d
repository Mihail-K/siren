
module siren.entity.association;

import siren.entity.base;
import siren.util.types;

import std.typecons;
import std.variant;

abstract class Association(E : Entity)
{
    @property
    abstract Association!(E) limit(ulong limit);

    @property
    abstract Association!(E) offset(ulong offset);

    @property
    abstract Association!(E) order(string field, string direction);

    @property
    abstract Association!(E) projection(string[] fields);

    @property
    abstract Association!(E) reorder(string field, string direction);

    @property
    abstract E take();

    @property
    abstract Association!(E) where(string field, Nullable!Variant value);

    @property
    Association!(E) where(T)(string field, T value)
    {
        return this.where(field, value.toNullableVariant);
    }
}
