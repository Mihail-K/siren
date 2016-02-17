
module siren.association.has_one;

import siren.entity;
import siren.relation;
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

    static HasOne!Owned create(Owner, Owned, string mapping)(Owner owner)
    {
        static assert(
            __traits(hasMember, Owned, mapping.toCamelCase),
            "Entity `" ~ Owned.stringof ~ "` doesn't have mapping `" ~ mapping.toCamelCase ~ "`."
        );

        return HasOne!Owned(new HasOneRelation!(Owner, Owned, mapping)(owner));
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
