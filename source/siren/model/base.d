
module siren.model.base;

import siren.database;
import siren.entity;
import siren.model.exception;
import siren.sirl;
import siren.util;

import std.conv;
import std.exception;
import std.typecons;
import std.variant;

class Model(E : Entity)
{
private:
    static Adapter _adapter;
    static Query _table;

    // Ensure the Entity has an ID column defined.
    static assert(hasID!E, "Entity `" ~ E.stringof ~ "` is missing an @ID column.");

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

        // Run the insert query and fetch the result.
        auto result = adapter.insert(query, E.stringof);

        // Set the entity ID from the query result.
        Nullable!Variant id = Variant(result.lastInsertID.get);
        set!(E, getIDColumnField!E)(entity, id);

        // Fire after entity-create callbacks.
        fire!(CallbackEvent.AfterCreate)(entity);

        // Ensure changes were made.
        return result.count != 0;
    }

    bool destroy(E entity)
    {
        auto query = table.destroy
            .where(getIDColumnName!E, getID(entity));

        // Fire before entity-destroy callbacks.
        fire!(CallbackEvent.BeforeDestroy)(entity);

        // Run the delete query and fetch the result.
        auto result = adapter.destroy(query, E.stringof);

        // Ensure that the entity was removed from the database.
        enforce(result != 0, EntityNotDestroyedException.create(entity));

        // Fire after entity-destroy callbacks.
        fire!(CallbackEvent.AfterDestroy)(entity);

        return result != 0;
    }

    static E find(IDType!E id)
    {
        auto query = table.select
            .projection(getColumnNames!E)
            .where(getIDColumnName!E, id)
            .limit(1);

        // Try to fetch the entity from the database.
        auto result = adapter.select(query, E.stringof);

        // Ensure that something was found by the query.
        enforce(!result.empty, EntityNotFoundException.create!(E)(id));

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

    Nullable!Variant getID(E entity)
    {
        return get!(E, getIDColumnField!E)(entity);
    }

    @property
    static Query table()
    {
        if(_table is null)
        {
            // Use lazy initialization.
            _table = new Query(tableName);
        }

        return _table;
    }

    @property
    enum string tableName = getTableName!E;

    private bool update(E entity)
    {
        // TODO : Run callbacks.
        // TODO : Run validations.
        // TODO : Run callbacks.

        auto columns = getNonIDColumnNames!E;
        auto values = get(entity, columns);

        auto query = table.update
            .where(getIDColumnName!E, getID(entity))
            .set(columns, values);

        // Fire before entity-update callbacks.
        fire!(CallbackEvent.BeforeUpdate)(entity);

        // Run the delete query and fetch the result.
        auto result = adapter.update(query, E.stringof);

        // Ensure that the entity was updated in the database.
        enforce(result != 0, EntityNotUpdatedException.create(entity));

        // Fire after entity-update callbacks.
        fire!(CallbackEvent.AfterUpdate)(entity);

        // Ensure changes were made.
        return result != 0;
    }
}
