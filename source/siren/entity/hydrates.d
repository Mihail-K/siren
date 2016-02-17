
module siren.entity.hydrates;

mixin template Hydrates()
{
    import siren.schema;
    import siren.util;

    import std.range;
    import std.typecons;
    import std.variant;

    Nullable!Variant[] get(string[] names)
    {
        auto values = new Nullable!Variant[names.length];

        OUTER: foreach(index, name; names)
        {
            foreach(column; tableColumns!tableDefinition)
            {
                enum field = column.name.toCamelCase;

                if(name == field)
                {
                    mixin("values[index] = this." ~ field ~ ".toNullableVariant;");
                    continue OUTER;
                }
            }
        }

        return values;
    }

    void set(string[] names, Nullable!Variant[] values)
    {
        OUTER: foreach(name, value; names.lockstep(values))
        {
            foreach(column; tableColumns!tableDefinition)
            {
                enum field = column.name.toCamelCase;

                if(name == field)
                {
                    mixin("alias ColumnType = " ~ column.dtype ~ ";");
                    auto result = value.fromNullableVariant!ColumnType;

                    mixin("this." ~ field ~ " = result;");
                    continue OUTER;
                }
            }
        }
    }

    void set(Nullable!Variant[string] values)
    {
        this.set(values.keys, values.values);
    }

    static typeof(this) construct(string[] fields, Nullable!Variant[] values)
    {
        auto entity = new typeof(this);

        // Hydrate entity.
        entity.hydrate(fields, values);

        // Raise an event if the entity supports them.
        static if(__traits(hasMember, entity, "raise"))
        {
            entity.raise(CallbackEvent.AfterLoad);
        }

        return entity;
    }
}
