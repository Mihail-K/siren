
module siren.entity.hydrates;

mixin template Hydrates()
{
    import siren.schema;
    import siren.util;

    import std.range;
    import std.typecons;
    import std.variant;

public:
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

    typeof(this) hydrate(string[] names, Nullable!Variant[] values)
    {
        this.set(names, values);

        // Populate associations if the entity supports them.
        static if(__traits(hasMember, typeof(this), "prepareAssociations"))
        {
            this.prepareAssociations;
        }

        return this;
    }

    typeof(this) hydrate(Nullable!Variant[string] values)
    {
        return this.hydrate(values.keys, values.values);
    }

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

    typeof(this) set(string[] names, Nullable!Variant[] values)
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

        return this;
    }

    typeof(this) set(Nullable!Variant[string] values)
    {
        return this.set(values.keys, values.values);
    }
}
