
module siren.entity.relation;

import siren.database;
import siren.entity.callback;
import siren.entity.has_many;
import siren.entity.has_one;
import siren.entity.owned_by;
import siren.schema;
import siren.sirl;
import siren.util;

import std.algorithm;
import std.array;
import std.typecons;
import std.variant;

class Relation(E)
{
private:
    SelectBuilder _builder;
    QueryResult _result;

public:
    this()
    {
        _builder = E.query.select;
    }

    @property
    bool empty()
    {
        if(_result is null)
        {
            _result = E.adapter.select(_builder, E.stringof);
        }

        return _result.empty;
    }

    static if(hasPrimary!(E.tableDefinition))
    {
        E find(PrimaryType!(E.tableDefinition) id)
        {
            return this
                .projection(tableColumnNames!(E.tableDefinition))
                .where(primaryColumn!(E.tableDefinition).name, id)
                .limit(1)
                .front;
        }

        E find(E entity)
        {
            enum primary = primaryColumn!(E.tableDefinition).name;
            auto id = __traits(getMember, entity, primary.toCamelCase);

            return find(id);
        }
    }

    @property
    E front()
    {
        if(_result is null)
        {
            _result = E.adapter.select(_builder, E.stringof);
        }

        if(!_result.empty)
        {
            auto row = _result.front;
            auto entity = new E;

            // Hydrate entity.
            auto fields = row.columns.map!toCamelCase.array;
            entity.hydrate(fields, row.toArray);

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

    @property
    Relation!(E) limit(ulong limit)
    {
        _builder.limit(limit);

        return this;
    }

    @property
    bool loaded()
    {
        return _result !is null;
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

    void popFront()
    {
        if(_result !is null)
        {
            _result.popFront;
        }
    }

    Relation!(E) projection(string[] fields...)
    {
        _builder.projection(fields);

        return this;
    }

    @property
    Relation!(E) reload()
    {
        _result = null;

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

mixin template Relations()
{
    import std.meta;
    import std.traits;

    static if(hasPrimary!(typeof(this).tableDefinition))
    {
        static typeof(this) find(PrimaryType!(typeof(this).tableDefinition) id)
        {
            return typeof(this).relation.find(id);
        }

        static typeof(this) find(typeof(this) entity)
        {
            return typeof(this).relation.find(entity);
        }

        static if(isNullableWrapped!(PrimaryType!(typeof(this).tableDefinition)))
        {
            static typeof(this) find(UnwrapNullable!(PrimaryType!(typeof(this).tableDefinition)) id)
            {
                PrimaryType!(typeof(this).tableDefinition) nullable = id;

                return typeof(this).find(nullable);
            }
        }
    }

    @property
    static auto relation()
    {
        return new Relation!(typeof(this));
    }

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
                enum _isRelation = isRelation!(member);
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
                enum foreign = typeof(this).tableDefinition.name ~ "_" ~
                               primaryColumn!(typeof(this).tableDefinition).name;

                static assert(
                    __traits(hasMember, Related, foreign.toCamelCase),
                    "Entity `" ~ Related.stringof ~ "` doesn't have mapping `" ~ foreign.toCamelCase ~ "`."
                );
            }
            else static if(__traits(isSame, Relationship, OwnedBy))
            {
                enum foreign = Related.tableDefinition.name ~ "_" ~
                               primaryColumn!(Related.tableDefinition).name;

                static assert(
                    __traits(hasMember, typeof(this), foreign.toCamelCase),
                    "Entity `" ~ typeof(this).stringof ~ "` doesn't have mapping `" ~ foreign.toCamelCase ~ "`."
                );
            }
        }
    }

    void hydrate(Nullable!Variant[string] values)
    {
        this.hydrate(values.keys, values.values);
    }
}

/+ - Compile-Time Helpers - +/
