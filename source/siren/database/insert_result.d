
module siren.database.insert_result;

import std.typecons;

abstract class InsertResult
{
    @property
    ulong count();

    @property
    Nullable!ulong lastInsertID();
}
