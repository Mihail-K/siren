
module siren.relation.base;

import siren.database;
import siren.entity;
import siren.relation.finders;
import siren.relation.queries;
import siren.schema;
import siren.sirl;
import siren.util;

import std.algorithm;
import std.array;
import std.range;
import std.string;
import std.traits;
import std.typecons;
import std.variant;

class Relation(Subject)
{
    mixin Finders!Subject;
    mixin Queries!Subject;

    static assert(isEntity!Subject);

private:
    SelectBuilder _query;
    Subject[] _results;

public:
    this()
    {
        _query = Subject.query.select;
        _results = null;
    }

    protected void applyQuery()
    {
        auto result = Subject.adapter.select(_query, Subject.stringof);

        _results = [ ];
        foreach(row; result)
        {
            auto fields = row.columns.map!toCamelCase.array;
            _results ~= new Subject(fields, row.toArray);
        }
    }

    @property
    bool empty()
    {
        return load, _results.empty;
    }

    @property
    Subject front()
    {
        return load, _results.front;
    }

    @property
    size_t length()
    {
        return load, _results.length;
    }

    @property
    Relation!Subject load()
    {
        if(!loaded)
        {
            applyQuery;
        }

        return this;
    }

    @property
    bool loaded()
    {
        return _results !is null;
    }

    size_t opDollar()
    {
        return length;
    }

    Subject opIndex(size_t index)
    {
        return load, _results[index];
    }

    Subject[] opSlice(size_t start, size_t stop)
    {
        return load, _results[start .. stop];
    }

    void popFront()
    {
        if(loaded)
        {
            _results.popFront;
        }
    }

    @property
    protected SelectBuilder query()
    {
        return _query;
    }

    @property
    Relation!Subject reload()
    {
        return reset, load;
    }

    @property
    Relation!Subject reset()
    {
        _query = Subject.query.select;
        _results = null;

        return this;
    }

    @property
    Subject[] results()
    {
        return load, _results;
    }

    @property
    InputRangeObject!(Subject[]) save()
    {
        return load, _results.inputRangeObject;
    }

    @property
    override string toString()
    {
        if(loaded)
        {
            return "Relation[%(%s, %)%s]".format(
                results.take(5), length > 5 ? ", ..." : ""
            );
        }
        else
        {
            return "Relation[ - ]";
        }
    }
}
