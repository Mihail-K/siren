
module siren.entity.mapped_by;

import siren.entity.attributes;
import siren.entity.base;
import siren.entity.id;
import siren.entity.table;

import std.traits;

struct MappedBy
{
private:
    string _column;

public:
    this(string column)
    {
        _column = column;
    }

    @property
    string column()
    {
        return _column;
    }
}

template hasMapping(E : Entity, string field)
{
    static if(isAccessibleField!(E, field))
    {
        enum hasMapping = getUDAs!(__traits(getMember, E, field), MappedBy).length > 0;
    }
    else
    {
        enum hasMapping = false;
    }
}

template getMappingColumn(E : Entity, string field)
{
    static if(hasMapping!(E, field))
    {
        enum getMappingColumn = getUDAs!(__traits(getMember, E, field), MappedBy)[0].column;
    }
    else
    {
        enum getMappingColumn = getDefaultMappingColumn!E;
    }
}

template getDefaultMappingColumn(E : Entity)
{
    enum getDefaultMappingColumn = getTableName!E ~ "_" ~ getIDColumnName!E;
}
