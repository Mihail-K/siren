
module siren.model.base;

import siren.database;
import siren.entity;
import siren.sirl;
import siren.util;

import std.conv;
import std.exception;

class Model(E : Entity)
{
private:
    static Adapter _adapter;
    static Query _table;

public:
    @property
    static Adapter adapter()
    {
        if(_adapter is null)
        {
            // Use lazy initialization.
            // TODO : Select adapter based on Entity.
            _adapter = AdapterProvider.get;
        }

        return _adapter;
    }

    private bool create(E entity)
    {
        // TODO : Run callbacks.
        // TODO : Run validations.
        // TODO : Run callbacks.

        auto query = table.insert
            .fields(getNonIDColumnNames!E)
            .values(get(entity, getNonIDColumnFields!E));

        // Fire before entity-create callbacks.
        fire!(CallbackEvent.BeforeCreate)(entity);

        auto result = adapter.insert(query, E.stringof);

        // Fire after entity-create callbacks.
        fire!(CallbackEvent.AfterCreate)(entity);

        return true;
    }

    bool destroy(E entity)
    {
        auto id = get(entity, getIDColumnField!E);

        auto columns = getNonIDColumnNames!E;
        auto values = get(entity, columns);

        auto query = table.destroy
            .where(getIDColumnName!E, id);

        // Fire before entity-destroy callbacks.
        fire!(CallbackEvent.BeforeDestroy)(entity);

        auto result = adapter.destroy(query, E.stringof);
        enforce(result != 0, "Entity `" ~ E.stringof ~ "` with id `" ~ id.text ~ "` not destroyed.");

        // Fire after entity-destroy callbacks.
        fire!(CallbackEvent.AfterDestroy)(entity);

        return true;
    }

    static E find(IDType!E id)
    {
        auto query = table.select
            .projection(getColumnNames!E)
            .where(getIDColumnName!E, id)
            .limit(1);

        auto result = adapter.select(query, E.stringof);
        enforce(!result.empty, "No " ~ E.stringof ~ " with id `" ~ id.text ~ "` found.");

        auto entity = new E;
        auto row = result.front;
        set(entity, row.columns, row.toArray);

        return entity;
    }

    static if(isNullableWrapped!(IDType!E))
    {
        static E find(UnwrapNullable!(IDType!E) id)
        {
            IDType!E realId = id;
            return find(realId);
        }
    }

    @property
    static Query table()
    {
        if(_table is null)
        {
            // Use lazy initialization.
            _table = new Query(getTableName!E);
        }

        return _table;
    }

    private bool update(E entity)
    {
        // TODO : Run callbacks.
        // TODO : Run validations.
        // TODO : Run callbacks.

        auto id = get(entity, getIDColumnField!E);

        auto columns = getNonIDColumnNames!E;
        auto values = get(entity, columns);

        auto query = table.update
            .where(getIDColumnName!E, id)
            .set(columns, values);

        // TODO : Run callbacks.

        auto result = adapter.update(query, E.stringof);

        // TODO : Run callbacks.

        return true;
    }
}
