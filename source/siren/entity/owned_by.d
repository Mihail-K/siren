
module siren.entity.owned_by;

import siren.entity.base;
import siren.entity.relation;

import std.range;

struct OwnedBy(E : Entity)
{
private:
    Relation!E _relation;
    E _value;

public:
    alias value this;

    this(Relation!E relation)
    {
        _relation = relation;
    }

    @property
    bool loaded()
    {
        return _relation.loaded;
    }

    @property
    E reload()
    {
        _relation.limit(1).reload;
        _value = _relation.front;

        return _value;
    }

    @property
    E value()
    {
        return loaded ? _value : reload;
    }
}
