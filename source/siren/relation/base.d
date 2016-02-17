
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
    QueryResult _result;

public:
    this()
    {
        select = Subject.query.select;
    }

    protected void apply()
    {
        _result = Subject.adapter.select(select, Subject.stringof);
    }

    @property
    bool loaded()
    {
        return _result !is null;
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
