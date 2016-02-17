
module siren.relation.ranges;

import siren.entity.base;

mixin template Ranges(Subject)
if(isEntity!Subject)
{
    import siren.database;
    import siren.entity;

    import std.algorithm;
    import std.array;

    // Ensure the outer type defines an apply function.
    static assert(__traits(hasMember, typeof(this), "apply"));

    // Ensure the outer type defines a result property.
    static assert(__traits(hasMember, typeof(this), "result"));

public:
    static struct ResultRange
    {
    private:
        QueryResult _result;

    public:
        this(QueryResult result)
        {
            _result = result;
        }

        @property
        bool empty()
        {
            return _result.empty;
        }

        @property
        Subject front()
        {
            if(!empty)
            {
                auto row = _result.first;
                auto fields = row.columns.map!toCamelCase.array;
                return Subject.construct(fields, row.toArray);
            }
            else
            {
                return null;
            }
        }

        void popFront()
        {
            if(_result !is null)
            {
                _result.popFront;
            }
        }

        @property
        ResultRange save()
        {
            return ResultRange(_result.save);
        }
    }

    @property
    bool empty()
    {
        if(result is null)
        {
            apply;
        }

        return result.empty;
    }

    @property
    Subject front()
    {
        if(!empty)
        {
            auto row = result.first;
            auto fields = row.columns.map!toCamelCase.array;
            return Subject.construct(fields, row.toArray);
        }
        else
        {
            return null;
        }
    }

    void popFront()
    {
        if(result !is null)
        {
            result.popFront;
        }
    }

    @property
    ResultRange save()
    {
        if(result is null)
        {
            apply;
        }

        return ResultRange(result.save);
    }
}
