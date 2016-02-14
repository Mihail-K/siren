
module siren.entity.relation;

import siren.entity.attributes;
import siren.entity.base;
import siren.entity.has_many;
import siren.entity.has_one;
import siren.entity.owned_by;
import siren.sirl;
import siren.util.types;

import std.meta;
import std.traits;
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
    abstract bool loaded();

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
    abstract Relation!(E) reload();

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

/+ - Compile-Time Helpers - +/

template isRelation(E : Entity, string member)
{
    static if(isAccessibleField!(E, member))
    {
        alias Type = typeof(__traits(getMember, E, member));

        static if(__traits(compiles, TemplateOf!Type))
        {
            enum isRelation = __traits(isSame, TemplateOf!Type, HasOne) ||
                              __traits(isSame, TemplateOf!Type, HasMany) ||
                              __traits(isSame, TemplateOf!Type, OwnedBy);
        }
        else
        {
            enum isRelation = false;
        }
    }
    else
    {
        enum isRelation = false;
    }
}

template RelationshipType(E : Entity, string member)
if(isRelation!(E, member))
{
    alias RelationshipType = TemplateOf!(RelationType!(E, member));
}

template RelationType(E : Entity, string member)
if(isRelation!(E, member))
{
    alias RelationType = typeof(__traits(getMember, E, member));
}

template RelatedType(E : Entity, string member)
if(isRelation!(E, member))
{
    alias RelatedType = TemplateArgsOf!(RelationType!(E, member))[0];
}

template getRelations(E : Entity)
{
    template _isRelation(string member)
    {
        enum _isRelation = isRelation!(E, member);
    }

    alias getRelations = Filter!(_isRelation, FieldNameTuple!E);
}
