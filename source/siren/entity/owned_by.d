
module siren.entity.owned_by;

import siren.entity.base;
import siren.entity.relation;

import std.range;

struct OwnedBy(E : Entity)
{
private:
    bool _loaded;
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
        return _loaded;
    }

    @property
    E reload()
    {
        // Limit the relation to one result.
        auto result = _relation.limit(1).take(1);

        _value = !result.empty ? result.front : null;
        _loaded = true;

        return _value;
    }

    @property
    E value()
    {
        return loaded ? _value : reload;
    }
}
