
module siren.association.has_one;

import siren.association.relation;
import siren.entity;
import siren.relation;
import siren.schema;
import siren.util;

struct HasOne(Subject)
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

    static HasOne!Subject create(Owner, string mapping)(Owner owner)
    {
        static assert(__traits(hasMember, Subject, mapping.toCamelCase));

        return HasOne!Subject(new HasOneRelation!(Owner, Subject, mapping)(owner));
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

class HasOneRelation(TList...) : AssocativeRelation!TList
{
public:
    this(Owner owner)
    {
        super(owner);
    }

    override Relation!Subject reset()
    {
        super.reset;

        enum primary = primaryColumn!(Subject.tableDefinition).name;
        auto id = __traits(getMember, this.owner, primary.toCamelCase);

        this.project(tableColumnNames!(Subject.tableDefinition))
            .where(mapping, id)
            .limit(1);

        return this;
    }
}
