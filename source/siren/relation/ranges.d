
module siren.relation.ranges;

import siren.entity.base;

mixin template Ranges(E)
if(isEntity!E)
{
    import siren.database;
    import siren.entity.callback;

    import std.algorithm;
    import std.array;

    // Ensure the outer type defines an apply function.
    static assert(__traits(hasMember, typeof(this), "apply"));

    // Ensure the outer type defines a result property.
    static assert(__traits(hasMember, typeof(this), "result"));

public:
    struct ResultRange
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
        E front()
        {
            if(!empty)
            {
                auto row = _result.front;
                auto entity = new E;

                // Hydrate entity.
                auto fields = row.columns.map!toCamelCase.array;
                entity.hydrate(fields, row.toArray);

                // Raise an event if the entity supports them.
                static if(__traits(hasMember, entity, "raise"))
                {
                    entity.raise(CallbackEvent.AfterLoad);
                }

                return entity;
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
        if(this.result is null)
        {
            this.apply;
        }

        return this.result.empty;
    }

    @property
    E front()
    {
        if(!this.empty)
        {
            auto row = this.result.front;
            auto entity = new E;

            // Hydrate entity.
            auto fields = row.columns.map!toCamelCase.array;
            entity.hydrate(fields, row.toArray);

            // Raise an event if the entity supports them.
            static if(__traits(hasMember, entity, "raise"))
            {
                entity.raise(CallbackEvent.AfterLoad);
            }

            return entity;
        }
        else
        {
            return null;
        }
    }

    void popFront()
    {
        if(this.result is null)
        {
            this.apply;
        }

        this.result.popFront;
    }

    @property
    ResultRange save()
    {
        if(this.result is null)
        {
            this.apply;
        }

        return ResultRange(this.result);
    }
}
