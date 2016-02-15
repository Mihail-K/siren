
module siren.entity.has_many;

import siren.entity.base;
import siren.entity.relation;

import std.range;

struct HasMany(E)
{
private:
    Relation!E _relation;

public:
    alias value this;

    this(Relation!E relation)
    {
        _relation = relation;
    }

    @property
    Relation!E value()
    {
        return _relation;
    }
}
