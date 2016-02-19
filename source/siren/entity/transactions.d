
module siren.entity.transactions;

mixin template Transactions()
{
    import siren.database;
    import siren.entity;

private:
    /++
     + Binds callbacks on the entity to the transaction.
     + This function has no effect if the entity does not support callbacks.
     ++/
    void registerTransactionCallbacks()
    {
        static if(__traits(hasMember, typeof(this), "raise"))
        {
            adapter.hook(delegate void(bool success)
            {
                if(success)
                {
                    this.raise(CallbackEvent.AfterCommit);
                }
                else
                {
                    this.raise(CallbackEvent.AfterRollback);
                }
            });
        }
    }

public:
    /++
     + Forwards to the Entity's adapter's transaction function.
     ++/
    static void transaction(void delegate(Adapter) callback)
    {
        adapter.transaction(callback);
    }

    /++
     + Ditto, but takes a function.
     ++/
    static void transaction(void function(Adapter) callback)
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

    /++
     + Ditto, but takes a function.
     ++/
    static void transaction(bool nested, void function(Adapter) callback)
    {
        adapter.transaction(nested, callback);
    }
}
