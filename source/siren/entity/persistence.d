
module siren.entity.persistence;

mixin template Persistence()
{
    import siren.database;
    import siren.entity;
    import siren.util;

    import std.algorithm;
    import std.array;

private:
    bool _destroyed;
    bool _persisted;

public:
    static bool create(string[] names, Nullable!Variant[] values)
    {
        return new typeof(this)(names, values).create;
    }

    static bool create(Nullable!Variant[string] values)
    {
        return typeof(this).create(values.keys, values.values);
    }

    bool create()
    {
        enum columns = [ typeof(this).columnNames ]
            .filter!(c => c != typeof(this).primaryKeyName)
            .array;
        enum fields = columns.map!toCamelCase.array;

        InsertResult result;
        auto q = typeof(this).query.insert
            .fields(columns)
            .values(this.get(fields));

        // Ensure a transaction is active.
        typeof(this).transaction(false, (adapter)
        {
            this.registerTransactionCallbacks;

            // Raise an BeforeCreate event if the entity supports it.
            static if(__traits(hasMember, typeof(this), "raise"))
            {
                this.raise(CallbackEvent.BeforeSave);
                this.raise(CallbackEvent.BeforeCreate);
            }

            result = adapter.insert(q, typeof(this).stringof);

            // Raise an AfterCreate event if the entity supports it.
            static if(__traits(hasMember, typeof(this), "raise"))
            {
                this.raise(CallbackEvent.AfterCreate);
                this.raise(CallbackEvent.AfterSave);
            }
        });

        if(result !is null)
        {
            auto id = result.lastInsertID;
            this.id = cast(typeof(this.id)) id.get;
            this._persisted = true;

            return result.count != 0;
        }
        else
        {
            return false;
        }
    }

    @property
    bool destroyed()
    {
        return this._destroyed;
    }

    @property
    bool persisted()
    {
        return !this.destroyed && this._persisted;
    }

    bool save()
    {
        if(this.persisted)
        {
            return this.update;
        }
        else
        {
            return this.create;
        }
    }

    bool update(string[] names, Nullable!Variant[] values)
    {
        this.set(names, values);

        return this.update;
    }

    bool update(Nullable!Variant[string] values)
    {
        this.set(values);

        return this.update;
    }

    bool update()
    {
        enum columns = [ typeof(this).columnNames ];
        enum fields = columns.map!toCamelCase.array;

        ulong result = 0;
        auto q = typeof(this).query.update
            .where(typeof(this).primaryKeyName, this.id)
            .set(columns, this.get(fields));

        // Ensure a transaction is active.
        typeof(this).transaction(false, (adapter)
        {
            this.registerTransactionCallbacks;

            // Raise an BeforeUpdate event if the entity supports it.
            static if(__traits(hasMember, typeof(this), "raise"))
            {
                this.raise(CallbackEvent.BeforeSave);
                this.raise(CallbackEvent.BeforeUpdate);
            }

            result = adapter.update(q, typeof(this).stringof);

            // Raise an AfterUpdate event if the entity supports it.
            static if(__traits(hasMember, typeof(this), "raise"))
            {
                this.raise(CallbackEvent.AfterUpdate);
                this.raise(CallbackEvent.AfterSave);
            }
        });

        return result != 0;
    }
}
