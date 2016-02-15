
module siren.entity.owned_by;

import siren.entity.base;
import siren.entity.relation;
import siren.schema;
import siren.util;

import std.range;

struct OwnedBy(Owner)
{
private:
    Relation!Owner _relation;
    Owner _value;

public:
    alias value this;

    this(Relation!Owner relation)
    {
        _relation = relation;
    }

    @property
    bool loaded()
    {
        return _relation.loaded;
    }

    @property
    Owner reload()
    {
        _value = _relation.reload.front;

        return _value;
    }

    @property
    Owner value()
    {
        return loaded ? _value : reload;
    }
}

class OwnedByRelation(Owner, Owned, string mapping) : Relation!(Owner)
{
private:
    Owned _owned;

public:
    this(Owned owned)
    {
        _owned = owned;
    }

    override void apply()
    {
        auto id = __traits(getMember, _owned, mapping.toCamelCase);

        builder
            .projection(tableColumnNames!(Owner.tableDefinition))
            .where(primaryColumn!(Owner.tableDefinition).name, id)
            .limit(1);

        super.apply;
    }
}
