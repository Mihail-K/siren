
module siren.entity.queries;

import siren.entity.base;

mixin template Queries(E)
if(isEntity!E)
{
    import siren.sirl;

    // Ensure outer type defines a query property.
    static assert(__traits(hasMember, typeof(this), "query"));

public:
    void clear()
    {
        this.query = E.query.select;
    }

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
        this.query.limit(limit);

        return this;
    }

    typeof(this) offset(ulong offset)
    {
        this.query.offset(offset);

        return this;
    }

    typeof(this) order(string field, string direction = "asc")
    {
        this.query.order(field, direction);

        return this;
    }

    typeof(this) project()
    {
        this.query.projection("*");

        return this;
    }

    typeof(this) project(string[] fields...)
    {
        this.query.projection(fields);

        return this;
    }

    typeof(this) reorder()
    {
        this.query.reorder;

        return this;
    }

    typeof(this) reorder(string field, string direction = "asc")
    {
        this.query.reorder(field, direction);

        return this;
    }

    typeof(this) where(ExpressionNode[] nodes...)
    {
        foreach(node; nodes)
        {
            this.query.where(node);
        }

        return this;
    }

    typeof(this) where(F, V)(F field, V value)
    if(!is(F == ExpressionNode) && !is(V == ExpressionNode))
    {
        this.query.where(field, value);

        return this;
    }
}
