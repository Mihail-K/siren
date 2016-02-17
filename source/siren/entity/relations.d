
module siren.entity.relations;

mixin template Relations()
{
    import siren.relation;
    import siren.sirl;

    // We need a table property to construct SIRL queries.
    static assert(__traits(hasMember, typeof(this), "table"));

private:
    static Query _query;

public:
    static typeof(this) find(T)(T id)
    {
        return typeof(this).relation.find(id);
    }

    static Relation!(typeof(this)) limit(ulong limit)
    {
        return typeof(this).relation.limit(limit);
    }

    static Relation!(typeof(this)) offset(ulong offset)
    {
        return typeof(this).relation.offset(offset);
    }

    static FieldNode opIndex(string field)
    {
        return typeof(this).query[field];
    }

    static Relation!(typeof(this)) order(TList...)(TList args)
    {
        return typeof(this).relation.order(args);
    }

    @property
    static Query query()
    {
        if(_query is null)
        {
            _query = new Query(typeof(this).table);
        }

        return _query;
    }

    static Relation!(typeof(this)) project(TList...)(TList args)
    {
        return typeof(this).relation.project(args);
    }

    @property
    protected static Relation!(typeof(this)) relation()
    {
        return new Relation!(typeof(this));
    }

    static Relation!(typeof(this)) reorder(TList...)(TList args)
    {
        return typeof(this).relation.reorder(args);
    }

    static Relation!(typeof(this)) where(TList...)(TList args)
    {
        return typeof(this).relation.where(args);
    }
}
