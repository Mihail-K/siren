
module siren.relation.has_one;

import siren.entity;
import siren.relation.base;
import siren.schema;
import siren.util;

struct HasOne(Owned)
{
private:
    Relation!Owned _relation;
    Owned _value;

public:
    alias value this;

    this(Relation!Owned relation)
    {
        _relation = relation;
    }

    @property
    bool loaded()
    {
        return _relation.loaded;
    }

    @property
    Owned reload()
    {
        _value = _relation.reload.front;

        return _value;
    }

    @property
    Owned value()
    {
        return loaded ? _value : reload;
    }
}

class HasOneRelation(Owner, Owned, string mapping) : Relation!(Owned)
{
private:
    Owner _owner;

public:
    this(Owner owner)
    {
        _owner = owner;
    }

    override void apply()
    {
        enum primary = primaryColumn!(Owner.tableDefinition).name;

        this.project(tableColumnNames!(Owned.tableDefinition))
            .where(mapping, __traits(getMember, _owner, primary.toCamelCase))
            .limit(1);

        super.apply;
    }
}