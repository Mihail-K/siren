
module siren.database.query_row;

import std.typecons;
import std.variant;

interface QueryRow
{
    @property
    string[] columns();

    Variant get(size_t index);

    bool isNull(size_t index);

    Nullable!Variant opIndex(size_t index);

    @property
    Nullable!Variant[] toArray();

    @property
    Nullable!Variant[string] toAssocArray();
}
