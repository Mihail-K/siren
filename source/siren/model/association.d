
module siren.model.association;

import siren.database;
import siren.entity;
import siren.model.base;
import siren.sirl;

import std.range;
import std.typecons;
import std.variant;

class ModelAssociation(M : Model!E, E : Entity) : Association!(E)
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
            set(entity, row.columns, row.toArray);
            return entity;
        }
        else
        {
            return null;
        }
    }

    override void popFront()
    {
        if(_result !is null)
        {
            _result.popFront;
        }
    }
}
