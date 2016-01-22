
module siren.entity.table;

import siren.entity.attributes;
import siren.entity.base;

import std.string;
import std.traits;

struct Table
{
private:
    string _name;

public:
    this(string name)
    {
        _name = name;
    }

    @property
    string name()
    {
        return _name;
    }
}

template getTable(E : Entity)
{
    static assert(isAccessible!E, "Entity `" ~ E.stringof ~ "` is not accessible.");

    static if(getUDAs!(E, Table).length > 0)
    {
        enum getTable = getUDAs!(E, Table)[0];
    }
    else
    {
        enum getTable = Table(E.stringof.toLower);
    }
}

template getTableName(E : Entity)
{
    enum getTableName = getTable!E.name;
}
