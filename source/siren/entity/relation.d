
module siren.entity.relation;

import siren.entity.base;
import siren.sirl;
import siren.util.types;

import std.typecons;
import std.variant;

abstract class Relation(E : Entity)
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
    Relation!(E) limit(ulong limit)
    {
        _builder.limit(limit);

        return this;
    }

    @property
    Relation!(E) offset(ulong offset)
    {
        _builder.offset(offset);

        return this;
    }

    @property
    Relation!(E) order(string field, string direction = "asc")
    {
        _builder.order(field, direction);

        return this;
    }

    abstract void popFront();

    @property
    Relation!(E) projection(string[] fields)
    {
        _builder.projection(fields);

        return this;
    }

    @property
    Relation!(E) reorder()
    {
        _builder.reorder;

        return this;
    }

    @property
    Relation!(E) reorder(string field, string direction)
    {
        _builder.reorder(field, direction);

        return this;
    }

    @property
    Relation!(E) where(ExpressionNode node)
    {
        _builder.where(node);

        return this;
    }

    @property
    Relation!(E) where(string field, Nullable!Variant value)
    {
        _builder.where(field, value);

        return this;
    }

    @property
    Relation!(E) where(T)(string field, T value)
    {
        return this.where(field, value.toNullableVariant);
    }
}
