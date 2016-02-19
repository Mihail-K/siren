
module siren.relation.queries;

mixin template Queries(Subject)
{
    import siren.entity;
    import siren.sirl;

    static assert(isEntity!Subject);

public:
    typeof(this) distinct()
    {
        return this; // TODO
    }

    typeof(this) group()
    {
        return this; // TODO
    }

    typeof(this) having()
    {
        return this; // TODO
    }

    typeof(this) join()
    {
        return this; // TODO
    }

    typeof(this) limit(ulong limit)
    {
        query.limit(limit);

        return this;
    }

    typeof(this) offset(ulong offset)
    {
        query.offset(offset);

        return this;
    }

    typeof(this) order(string field, string direction = "asc")
    {
        query.order(field, direction);

        return this;
    }

    typeof(this) project()
    {
        query.projection("*");

        return this;
    }

    typeof(this) project(string[] fields...)
    {
        query.projection(fields);

        return this;
    }

    typeof(this) reorder()
    {
        query.reorder;

        return this;
    }

    typeof(this) reorder(string field, string direction = "asc")
    {
        query.reorder(field, direction);

        return this;
    }

    typeof(this) where(ExpressionNode[] nodes...)
    {
        foreach(node; nodes)
        {
            query.where(node);
        }

        return this;
    }

    typeof(this) where(F, V)(F field, V value)
    {
        query.where(field, value);

        return this;
    }
}
