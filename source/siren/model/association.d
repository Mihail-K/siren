
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
    SelectBuilder _query;

public:
    this(Adapter adapter, SelectBuilder query)
    {
        _adapter = adapter;
        _query = query;
    }

    @property
    override ModelAssociation!(M, E) limit(ulong limit)
    {
        _query.limit(limit);

        return this;
    }

    @property
    override ModelAssociation!(M, E) offset(ulong offset)
    {
        _query.offset(offset);

        return this;
    }

    @property
    override ModelAssociation!(M, E) order(string field, string direction)
    {
        _query.order(field, direction);

        return this;
    }

    @property
    override ModelAssociation!(M, E) projection(string[] fields)
    {
        _query.projection(fields);

        return this;
    }

    @property
    override ModelAssociation!(M, E) reorder(string field, string direction)
    {
        _query.reorder(field, direction);

        return this;
    }

    @property
    override E take()
    {
        auto result = _adapter.select(_query);

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

    @property
    override ModelAssociation!(M, E) where(string field, Nullable!Variant value)
    {
        _query.where(field, value);

        return this;
    }

    // Local where shadows parent.
    alias where = Association!(E).where;
}
