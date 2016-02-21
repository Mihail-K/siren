
module siren.entity.dirty;

struct Changes(Type)
{
private:
    Type _current;
    Type _previous;

public:
    @disable
    this();

    this(Type current, Type previous)
    {
        _current = current;
        _previous = previous;
    }

    @property
    Type current() const
    {
        return _current;
    }

    @property
    Type previous() const
    {
        return _previous;
    }
}

mixin template Dirty()
{
    import siren.entity;
    import siren.schema;
    import siren.util;

    import std.meta;

private:
    FieldStates __clean;

    enum bool __DirtySupported = true;

public:
    string[] changes()
    {
        string[] changes;

        foreach(column; typeof(this).columnNames)
        {
            enum field = column.toCamelCase;

            if(this.dirty!field)
            {
                changes ~= field;
            }
        }

        return changes;
    }

    auto changes(string field)()
    {
        alias Type = typeof(__traits(getMember, this.__fields, "_" ~ field));

        return Changes!Type(
            __traits(getMember, this.__fields, "_" ~ field),
            __traits(getMember, this.__clean, "_" ~ field)
        );
    }

    bool clean()
    {
        return !this.dirty;
    }

    bool clean(string field)()
    {
        return !this.dirty!field;
    }

    bool dirty()
    {
        foreach(column; typeof(this).columnNames)
        {
            enum field = column.toCamelCase;
            if(this.dirty!field) return true;
        }

        return false;
    }

    bool dirty(string field)()
    {
        return __traits(getMember, this.__fields, "_" ~ field) !=
               __traits(getMember, this.__clean, "_" ~ field);
    }

    private void updateCleanStates()
    {
        this.__clean = this.__fields;
    }
}
