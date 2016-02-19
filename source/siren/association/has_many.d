
module siren.association.has_many;

import siren.entity;
import siren.relation;
import siren.schema;
import siren.util;

struct HasMany(Subject)
{
private:
    Relation!Subject _relation;

public:
    alias value this;

    this(Relation!Subject relation)
    {
        _relation = relation;
    }

    static HasMany!Subject create(Owner, string mapping)(Owner owner)
    {
        static assert(__traits(hasMember, Subject, mapping.toCamelCase));

        return HasMany!Subject(new HasManyRelation!(Owner, Subject, mapping)(owner));
    }

    @property
    Relation!Subject value()
    {
        return _relation;
    }
}

class HasManyRelation(TList...) : AssocativeRelation!TList
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
            .where(mapping, id);
    }
}
