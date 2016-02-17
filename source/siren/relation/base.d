
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

class Relation(Subject)
{
    mixin Queries!Subject;
    mixin Ranges!Subject;

    static assert(isEntity!Subject);

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
        _result = Subject.adapter.select(query, Subject.stringof);
    }

    static if(hasPrimary!(Subject.tableDefinition))
    {
        Subject find(PrimaryType!(Subject.tableDefinition) id)
        {
            scope(success)
            {
                this.popFront;
            }

            return this
                .project(tableColumnNames!(Subject.tableDefinition))
                .where(primaryColumn!(Subject.tableDefinition).name, id)
                .limit(1)
                .front;
        }

        Subject find(Subject entity)
        {
            enum primary = primaryColumn!(Subject.tableDefinition).name;
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
    Relation!Subject reload()
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
