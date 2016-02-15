
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

abstract class Relation(E)
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

mixin template HydarateFunctions()
{
    import std.meta;
    import std.traits;

    void hydrate(string[] names, Nullable!Variant[] values)
    {
        template isRelation(string member)
        {
            alias Type = typeof(__traits(getMember, typeof(this), member));

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

        template RelationshipType(string member)
        if(isRelation!member)
        {
            alias RelationshipType = TemplateOf!(RelationType!member);
        }

        template RelationType(string member)
        if(isRelation!member)
        {
            alias RelationType = typeof(__traits(getMember, typeof(this), member));
        }

        template RelatedType(string member)
        if(isRelation!member)
        {
            alias RelatedType = TemplateArgsOf!(RelationType!member)[0];
        }

        template getRelations(E)
        {
            template _isRelation(string member)
            {
                enum _isRelation = isRelation!(E, member);
            }

            alias getRelations = Filter!(_isRelation, FieldNameTuple!E);
        }

        this.set(names, values);

        foreach(relation; getRelations!(typeof(this)))
        {
            alias Related = RelatedType!relation;
            alias Relationship = RelationshipType!relation;

            static if(__traits(isSame, Relationship, HasOne))
            {
            }
        }
    }

    void hydrate(Nullable!Variant[string] values)
    {
        this.hydrate(values.keys, values.values);
    }
}

/+ - Compile-Time Helpers - +/
