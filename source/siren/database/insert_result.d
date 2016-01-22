
module siren.database.insert_result;

import std.typecons;

interface InsertResult
{
    @property
    ulong count();

    @property
    Nullable!ulong lastInsertID();
}
