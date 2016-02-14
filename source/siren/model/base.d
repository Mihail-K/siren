
module siren.model.base;

import siren.database;
import siren.entity;
import siren.model.exception;
import siren.model.hydrate;
import siren.model.relation;
import siren.sirl;
import siren.util;

import std.conv;
import std.exception;
import std.typecons;
import std.variant;

final class Model(E : Entity)
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

        if(!_adapter.connected)
        {
            // Connect to DB.
            _adapter.connect;
        }

        return _adapter;
    }

    static bool create(E entity)
    {
        // Fire before entity-validation callbacks.
        fire!(CallbackEvent.BeforeValidation)(entity);

        // TODO : Run validations.

        // Fire after entity-validation callbacks.
        fire!(CallbackEvent.AfterValidation)(entity);

        InsertResult result;
        auto query = table.insert
            .fields(getNonIDColumnNames!E)
            .values(get(entity, [ getNonIDColumnFields!E ]));

        // Run in a transaction.
        transaction(false, (adapter) {
            // Fire before entity-create callbacks.
            fire!(CallbackEvent.BeforeCreate)(entity);

            // Run the insert query and fetch the result.
            result = adapter.insert(query, E.stringof);

            // Set the entity ID from the query result.
            Nullable!Variant id = Variant(result.lastInsertID.get);
            hydrate(entity, [ getIDColumnField!E ], [ id ]);

            // Fire after entity-create callbacks.
            fire!(CallbackEvent.AfterCreate)(entity);
        });

        // Ensure changes were made.
        return result.count != 0;
    }

    static bool destroy(E entity)
    {
        ulong result;
        auto query = table.destroy
            .where(getIDColumnName!E, getID(entity));

        // Run in a transaction.
        transaction(false, (adapter) {
            // Fire before entity-destroy callbacks.
            fire!(CallbackEvent.BeforeDestroy)(entity);

            // Run the delete query and fetch the result.
            result = adapter.destroy(query, E.stringof);

            // Ensure that the entity was removed from the database.
            enforce(result != 0, EntityNotDestroyedException.create(entity));

            // Fire after entity-destroy callbacks.
            fire!(CallbackEvent.AfterDestroy)(entity);
        });

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
        hydrate(entity, row.columns, row.toArray);

        // Fire after entity-load callbacks.
        fire!(CallbackEvent.AfterLoad)(entity);

        return entity;
    }

    static E find(E entity)
    {
        auto id = getID(entity);
        return find(id.get.get!(IDType!E));
    }

    static if(isNullableWrapped!(IDType!E))
    {
        static E find(UnwrapNullable!(IDType!E) id)
        {
            IDType!E realId = id;
            return find(realId);
        }
    }

    static Nullable!Variant getID(E entity)
    {
        return get!(E, getIDColumnField!E)(entity);
    }

    static auto opIndex(string column)
    {
        return table[column];
    }

    static auto order(TList...)(TList args)
    {
        return relation.order(args);
    }

    @property
    static auto relation()
    {
        return new ModelRelation!(typeof(this))(table.select, adapter, tableName);
    }

    static bool save(E entity)
    {
        auto id = getID(entity);

        // Check if the entity has its ID field set.
        if(id.isNull || id.get.get!(IDType!E) == IDType!E.init)
        {
            return create(entity);
        }
        else
        {
            return update(entity);
        }
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

    /++
     + Forwards to the Model's adapter's transaction function.
     ++/
    static void transaction(void delegate(Adapter) callback)
    {
        adapter.transaction(callback);
    }

    /++
     + Ditto.
     ++/
    static void transaction(bool nested, void delegate(Adapter) callback)
    {
        adapter.transaction(nested, callback);
    }

    static bool update(E entity)
    {
        // Fire before entity-validation callbacks.
        fire!(CallbackEvent.BeforeValidation)(entity);

        // TODO : Run validations.

        // Fire after entity-validation callbacks.
        fire!(CallbackEvent.AfterValidation)(entity);

        auto columns = [ getNonIDColumnNames!E ];
        auto values = get(entity, columns);

        ulong result;
        auto query = table.update
            .where(getIDColumnName!E, getID(entity))
            .set(columns, values);

        // Run in a transaction.
        transaction(false, (adapter) {
            // Fire before entity-update callbacks.
            fire!(CallbackEvent.BeforeUpdate)(entity);

            // Run the delete query and fetch the result.
            result = adapter.update(query, E.stringof);

            // Ensure that the entity was updated in the database.
            enforce(result != 0, EntityNotUpdatedException.create(entity));

            // Fire after entity-update callbacks.
            fire!(CallbackEvent.AfterUpdate)(entity);
        });

        // Ensure changes were made.
        return result != 0;
    }

    @property
    static auto where(TList...)(TList args)
    if(__traits(compiles, { relation.where(args); }))
    {
        return relation.where(args);
    }
}
