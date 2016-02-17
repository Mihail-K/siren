
module siren.relation.queries;

mixin template Queries(Subject)
{
    import siren.entity;
    import siren.sirl;

    static assert(isEntity!Subject);

private:
    SelectBuilder _select;

public:
    typeof(this) clear()
    {
        select = Subject.query.select;

        return this;
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
        select.limit(limit);

        return this;
    }

    typeof(this) offset(ulong offset)
    {
        select.offset(offset);

        return this;
    }

    typeof(this) order(string field, string direction = "asc")
    {
        select.order(field, direction);

        return this;
    }

    typeof(this) project()
    {
        select.projection("*");

        return this;
    }

    typeof(this) project(string[] fields...)
    {
        select.projection(fields);

        return this;
    }

    typeof(this) reorder()
    {
        select.reorder;

        return this;
    }

    typeof(this) reorder(string field, string direction = "asc")
    {
        select.reorder(field, direction);

        return this;
    }

    @property
    protected SelectBuilder select()
    {
        return _select;
    }

    @property
    protected SelectBuilder select(SelectBuilder select)
    {
        return _select = select;
    }

    typeof(this) where(ExpressionNode[] nodes...)
    {
        foreach(node; nodes)
        {
            select.where(node);
        }

        return this;
    }

    typeof(this) where(F, V)(F field, V value)
    {
        select.where(field, value);

        return this;
    }
}
