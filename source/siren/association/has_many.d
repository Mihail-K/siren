
module siren.association.has_many;

import siren.entity;
import siren.relation;
import siren.schema;
import siren.util;

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

    static HasMany!Owned create(Owner, Owned, string mapping)(Owner owner)
    {
        static assert(
            __traits(hasMember, Owned, mapping.toCamelCase),
            "Entity `" ~ Owned.stringof ~ "` doesn't have mapping `" ~ mapping.toCamelCase ~ "`."
        );

        return HasMany!Owned(new HasManyRelation!(Owner, Owned, mapping)(owner));
    }

    @property
    Relation!E value()
    {
        return _relation;
    }
}

class HasManyRelation(Owner, Owned, string mapping) : Relation!(Owned)
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
            .where(mapping, __traits(getMember, _owner, primary.toCamelCase));

        super.apply;
    }
}
