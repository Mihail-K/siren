
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
