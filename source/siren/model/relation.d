
module siren.model.relation;

import siren.database;
import siren.entity;
import siren.model.base;
import siren.model.hydrate;
import siren.sirl;

import std.range;
import std.typecons;
import std.variant;

class ModelRelation(M) : Relation!(M)
{
private:
    Adapter _adapter;
    string _context;

    QueryResult _result;

public:
    this(SelectBuilder builder, Adapter adapter, string context = null)
    {
        super(builder);

        _adapter = adapter;
        _context = context;
    }

    @property
    override bool empty()
    {
        if(_result is null)
        {
            _result = _adapter.select(builder, _context);
        }

        return _result.empty;
    }

    @property
    override E front()
    {
        if(_result is null)
        {
            _result = _adapter.select(builder, _context);
        }

        if(!_result.empty)
        {
            auto row = _result.front;
            auto entity = new E;

            // Hydrate entity.
            hydrate(entity, toFields(entity, row.columns), row.toArray);
            return entity;
        }
        else
        {
            return null;
        }
    }

    @property
    override bool loaded()
    {
        return _result !is null;
    }

    override void popFront()
    {
        if(_result !is null)
        {
            _result.popFront;
        }
    }

    @property
    override ModelRelation!(M, E) reload()
    {
        _result = null;

        return this;
    }
}
