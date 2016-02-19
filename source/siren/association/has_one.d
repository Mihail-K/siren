
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
        static assert(Subject.hasColumn!mapping);

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

    override SelectBuilder defaultQuery()
    {
        auto id = __traits(getMember, this.owner, Subject.primaryColumnField);

        return super.defaultQuery
            .projection(Subject.columnNames)
            .where(mapping, id)
            .limit(1);
    }
}
