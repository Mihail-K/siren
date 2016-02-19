
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
            // Raise an BeforeCreate event if the entity supports it.
            static if(__traits(hasMember, typeof(this), "raise"))
            {
                this.raise(CallbackEvent.BeforeCreate);
            }

            result = adapter.insert(q, typeof(this).stringof);

            // Raise an AfterCreate event if the entity supports it.
            static if(__traits(hasMember, typeof(this), "raise"))
            {
                this.raise(CallbackEvent.AfterCreate);
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

        enum columns = [ typeof(this).columnNames ];
        enum fields = columns.map!toCamelCase.array;

        ulong result = 0;
        auto q = typeof(this).query.update
            .where(typeof(this).primaryKeyName, this.id)
            .set(columns, this.get(fields));

        // Ensure a transaction is active.
        typeof(this).transaction(false, (adapter)
        {
            // Raise an BeforeUpdate event if the entity supports it.
            static if(__traits(hasMember, typeof(this), "raise"))
            {
                this.raise(CallbackEvent.BeforeUpdate);
            }

            result = adapter.update(q, typeof(this).stringof);

            // Raise an AfterUpdate event if the entity supports it.
            static if(__traits(hasMember, typeof(this), "raise"))
            {
                this.raise(CallbackEvent.AfterUpdate);
            }
        });

        return result != 0;
    }

    bool update(Nullable!Variant[string] values)
    {
        return this.update(values.keys, values.values);
    }

    bool update()
    {
        return this.update(cast(string[]) [], cast(Nullable!Variant[]) []);
    }
}
