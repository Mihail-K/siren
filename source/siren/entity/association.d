
module siren.entity.association;

import siren.entity.base;
import siren.sirl;
import siren.util.types;

import std.typecons;
import std.variant;

abstract class Association(E : Entity)
{
private:
    SelectBuilder _builder;

public:
    this(SelectBuilder builder)
    {
        _builder = builder;
    }

    @property
    protected SelectBuilder builder()
    {
        return _builder;
    }

    @property
    abstract bool empty();

    @property
    abstract E front();

    @property
    Association!(E) limit(ulong limit)
    {
        _builder.limit(limit);

        return this;
    }

    @property
    Association!(E) offset(ulong offset)
    {
        _builder.offset(offset);

        return this;
    }

    @property
    Association!(E) order(string field, string direction)
    {
        _builder.order(field, direction);

        return this;
    }

    abstract void popFront();

    @property
    Association!(E) projection(string[] fields)
    {
        _builder.projection(fields);

        return this;
    }

    @property
    Association!(E) reorder(string field, string direction)
    {
        _builder.reorder(field, direction);

        return this;
    }

    @property
    abstract E take();

    @property
    Association!(E) where(ExpressionNode node)
    {
        _builder.where(node);

        return this;
    }

    @property
    Association!(E) where(string field, Nullable!Variant value)
    {
        _builder.where(field, value);

        return this;
    }

    @property
    Association!(E) where(T)(string field, T value)
    {
        return this.where(field, value.toNullableVariant);
    }
}
