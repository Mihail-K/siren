
module siren.entity.ranges;

import siren.entity.base;

mixin template Ranges(E)
if(isEntity!E)
{
    import siren.database;
    import siren.entity.callback;

    import std.algorithm;
    import std.array;
    import std.typecons;

    static assert(__traits(hasMember, typeof(this), "apply"));
    static assert(__traits(hasMember, typeof(this), "result"));

public:
    @property
    bool empty()
    {
        if(result is null)
        {
            this.apply;
        }

        return result.empty;
    }

    @property
    E front()
    {
        if(!this.empty)
        {
            auto row = result.front;
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
        if(result !is null)
        {
            result.popFront;
        }
    }
}
