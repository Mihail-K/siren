
module siren.relation.base;

import siren.database;
import siren.entity;
import siren.relation.finders;
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
    mixin Finders!Subject;
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
