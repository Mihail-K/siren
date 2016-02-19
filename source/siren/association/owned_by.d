
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
        static assert(Owner.hasColumn!mapping);

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

    override SelectBuilder defaultQuery()
    {
        auto id = __traits(getMember, this.owner, mapping.toCamelCase);

        return super.defaultQuery
            .projection(Subject.columnNames)
            .where(Subject.primaryColumnName, id)
            .limit(1);
    }
}
