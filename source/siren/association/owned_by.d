
module siren.association.owned_by;

import siren.association.relation;
import siren.entity;
import siren.relation;
import siren.schema;
import siren.util;

struct OwnedBy(Subject)
{
private:
    Relation!Subject _relation;
    Subject _value;

public:
    alias value this;

    this(Relation!Subject relation)
    {
        _relation = relation;
    }

    static OwnedBy!Subject create(Owner, string mapping)(Owner owner)
    {
        static assert(
            __traits(hasMember, Owner, mapping.toCamelCase),
            "Entity `" ~ Owner.stringof ~ "` doesn't have mapping `" ~ mapping.toCamelCase ~ "`."
        );

        return OwnedBy!Subject(new OwnedByRelation!(Owner, Subject, mapping)(owner));
    }

    @property
    bool loaded()
    {
        return _relation.loaded;
    }

    @property
    Subject reload()
    {
        _value = _relation.reload.front;

        return _value;
    }

    @property
    Subject value()
    {
        return loaded ? _value : reload;
    }
}

class OwnedByRelation(TList...) : AssocativeRelation!TList
{
public:
    this(Owner owner)
    {
        super(owner);
    }

    override void apply()
    {
        auto id = __traits(getMember, this.owner, mapping.toCamelCase);

        this.project(tableColumnNames!(Subject.tableDefinition))
            .where(primaryColumn!(Subject.tableDefinition).name, id)
            .limit(1);

        super.apply;
    }
}
