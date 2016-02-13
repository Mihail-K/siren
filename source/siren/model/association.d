
module siren.model.association;

import siren.database;
import siren.entity;
import siren.model.base;
import siren.sirl;

import std.typecons;
import std.variant;

class ModelAssociation(M : Model!E, E : Entity) : Association!(E)
{
private:
    Adapter _adapter;
    string _context;

public:
    this(SelectBuilder builder, Adapter adapter, string context = null)
    {
        super(builder);

        _adapter = adapter;
        _context = context;
    }

    @property
    override E take()
    {
        auto result = _adapter.select(builder, _context);

        if(!result.empty)
        {
            auto entity = new E;
            auto row = result.front;

            // Hydrate entity.
            set(entity, row.columns, row.toArray);
            return entity;
        }
        else
        {
            return null;
        }
    }
}
