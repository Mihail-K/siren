
module siren.entity.construction;

mixin template Construction()
{
    import siren.entity;
    import siren.util;

    import std.range;
    import std.typecons;
    import std.variant;

public:
    /++
     + Constructs and hydrates the Entity.
     ++/
    this(string[] fields, Nullable!Variant[] values)
    {
        this.hydrate(fields, values);

        // Raise an event if the entity supports them.
        static if(__traits(hasMember, this, "raise"))
        {
            this.raise(CallbackEvent.AfterLoad);
        }
    }

    /++
     + Ditto, but takes an associative array.
     ++/
    this(Nullable!Variant[string] fields)
    {
        this(fields.keys, fields.values);
    }

    /++
     + Ditto, but takes no parameters.
     ++/
    this()
    {
        this(cast(string[]) [], cast(Nullable!Variant[]) []);
    }

    /++
     + Hydrates this instance of the Entity using two arrays containing fields
     + corresponding to values, and preparing any assocations on the Entity,
     + given the Entity type supports them.
     ++/
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

    /++
     + Ditto, but takes parameters as an associative array.
     ++/
    typeof(this) hydrate(Nullable!Variant[string] values)
    {
        return this.hydrate(values.keys, values.values);
    }

    /++
     + Reads values from the Entity's mapped fields (defined in the Schema).
     ++/
    Nullable!Variant[] get(string[] names)
    {
        auto values = new Nullable!Variant[names.length];

        OUTER: foreach(index, name; names)
        {
            foreach(column; typeof(this).columnDefintions)
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

    /++
     + Writes values to the Entity's mapped fields (defined in the Schema).
     + Values are given by two arrays containing fields corresponding to values.
     ++/
    typeof(this) set(string[] names, Nullable!Variant[] values)
    {
        OUTER: foreach(name, value; names.lockstep(values))
        {
            foreach(column; typeof(this).columnDefintions)
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

    /++
     + Ditto, but takes parameters as an associative array.
     ++/
    typeof(this) set(Nullable!Variant[string] values)
    {
        return this.set(values.keys, values.values);
    }
}
