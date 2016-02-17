
module siren.relation.base;

import siren.database;
import siren.entity;
import siren.relation.queries;
import siren.relation.ranges;
import siren.schema;
import siren.sirl;
import siren.util;

import std.algorithm;
import std.array;
import std.traits;
import std.typecons;
import std.variant;

class Relation(E)
{
    mixin Queries!E;
    mixin Ranges!E;

private:
    SelectBuilder _query;
    QueryResult _result;

public:
    this()
    {
        this.clear;
    }

    protected void apply()
    {
        _result = E.adapter.select(query, E.stringof);
    }

    static if(hasPrimary!(E.tableDefinition))
    {
        E find(PrimaryType!(E.tableDefinition) id)
        {
            scope(success)
            {
                this.popFront;
            }

            return this
                .project(tableColumnNames!(E.tableDefinition))
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
    bool loaded()
    {
        return _result !is null;
    }

    @property
    protected SelectBuilder query()
    {
        return _query;
    }

    @property
    protected SelectBuilder query(SelectBuilder query)
    {
        return _query = query;
    }

    @property
    Relation!(E) reload()
    {
        _result = null;

        return this;
    }

    @property
    protected QueryResult result()
    {
        return _result;
    }
}

template isRelation(Type)
{
    static if(__traits(compiles, TemplateOf!Type))
    {
        import siren.relation.has_many;
        import siren.relation.has_one;
        import siren.relation.owned_by;

        enum isRelation = __traits(isSame, TemplateOf!Type, HasOne) ||
                          __traits(isSame, TemplateOf!Type, HasMany) ||
                          __traits(isSame, TemplateOf!Type, OwnedBy);
    }
    else
    {
        enum isRelation = false;
    }
}

template RelationType(Type)
if(isRelation!Type)
{
    alias RelationType = TemplateOf!Type;
}

template RelatedType(Type)
if(isRelation!Type)
{
    alias RelatedType = TemplateArgsOf!Type[0];
}
