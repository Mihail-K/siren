
module siren.database.adapter;

import siren.database.insert_result;
import siren.database.query_result;
import siren.database.rollback;
import siren.sirl;
import siren.util;

import std.functional;
import std.typecons;
import std.variant;

abstract class Adapter
{
    /++
     + Binds parameters to an SQL-string template.
     ++/
    abstract EscapedString bind(EscapedString sql, Nullable!Variant[] parameters...);

    /++
     + Closes the connection permanently and performs necessary clean up.
     ++/
    abstract void close();

    /++
     + Commits and exits the current database transaction.
     ++/
    abstract void commit();

    /++
     + Connects to the database, unless already connected.
     ++/
    abstract void connect();

    /++
     + Checks if the adapter has an open connection to a database.
     ++/
    @property
    abstract bool connected();

    /++
     + The raw database connection object used by the adapter.
     ++/
    @property
    abstract Object connection(); // TODO : Connection type.

    /++
     + An alias for destroy.
     ++/
    alias delete_ = destroy;

    abstract ulong destroy(EscapedString sql, string context);

    ulong destroy(EscapedString sql, Nullable!Variant[] parameters = []...)
    {
        return destroy(bind(sql, parameters), cast(string) null);
    }

    ulong destroy(EscapedString sql, string context, Nullable!Variant[] parameters = []...)
    {
        return destroy(bind(sql, parameters), context);
    }

    /++
     + Runs a DELETE statement using a constructed SIRL query.
     ++/
    abstract ulong destroy(DeleteBuilder sirl, string context = null);

    /++
     + Closes the current database connection.
     ++/
    abstract void disconnect();

    /++
     + Escapes a raw SQL string.
     ++/
    abstract EscapedString escape(string raw);

    abstract ulong exec(EscapedString sql, string context);

    ulong exec(EscapedString sql, Nullable!Variant[] parameters = []...)
    {
        return exec(bind(sql, parameters), cast(string) null);
    }

    ulong exec(EscapedString sql, string context, Nullable!Variant[] parameters = []...)
    {
        return exec(bind(sql, parameters), context);
    }

    /++
     + Adds a hook function to be executed once the current transaction ends.
     ++/
    void hook(void function(bool success) callback)
    {
        this.hook(callback.toDelegate);
    }

    /++
     + Adds a hook delegate to be executed once the current transaction ends.
     ++/
    void hook(void delegate(bool success) callback);

    abstract InsertResult insert(EscapedString sql, string context);

    InsertResult insert(EscapedString sql, Nullable!Variant[] parameters = []...)
    {
        return insert(bind(sql, parameters), cast(string) null);
    }

    InsertResult insert(EscapedString sql, string context, Nullable!Variant[] parameters = []...)
    {
        return insert(bind(sql, parameters), context);
    }

    /++
     + Runs an INSERT statement using a constructed SIRL query.
     ++/
    abstract InsertResult insert(InsertBuilder sirl, string context = null);

    /++
     + Checks if there is an active transaction.
     ++/
    @property
    abstract bool inTransaction();

    /++
     + A human-readable name for the database adapter.
     ++/
    @property
    abstract string name();

    abstract QueryResult select(EscapedString sql, string context);

    QueryResult select(EscapedString sql, Nullable!Variant[] parameters = []...)
    {
        return select(bind(sql, parameters), cast(string) null);
    }

    QueryResult select(EscapedString sql, string context, Nullable!Variant[] parameters = []...)
    {
        return select(bind(sql, parameters), context);
    }

    /++
     + Runs a SELECT statement using a constructed SIRL query.
     ++/
    abstract QueryResult select(SelectBuilder sirl, string context = null);

    /++
     + Closes the active connection, if open, and reconnects to the database.
     ++/
    abstract void reconnect();

    /++
     + Rolls back and exits the current database transaction.
     ++/
    abstract void rollback();

    /++
     + Starts a new database transaction.
     ++/
    abstract void transaction();

    /++
     + Executes a delegate in a transaction, rolling-back if an exception is thrown.
     + This won't created a nested transaction if one is already active.
     ++/
    void transaction(void delegate(Adapter adapter) callback)
    {
        this.transaction(false, callback);
    }

    /++
     + Ditto
     +
     + Params:
     +   nested   = If true, a nested transaction will be started.
     +   callback = The delegate to wrap in a transaction.
     ++/
    void transaction(bool nested, void delegate(Adapter adapter) callback)
    {
        try
        {
            bool started;

            // Start a new transaction.
            if(!inTransaction || nested)
            {
                transaction;
                started = true;
            }

            scope(failure)
            {
                // Rollback on failure.
                if(started) rollback;
            }

            callback(this);
        }
        catch(Rollback r)
        {
            if(r.propogate)
            {
                throw r;
            }
        }
    }

    /++
     + Executes a function in a transaction, rolling-back if an exception is thrown.
     + This won't created a nested transaction if one is already active.
     ++/
    void transaction(void function(Adapter adapter) callback)
    {
        this.transaction(false, callback);
    }

    /++
     + Ditto
     +
     + Params:
     +   nested   = If true, a nested transaction will be started.
     +   callback = The function to wrap in a transaction.
     ++/
    void transaction(bool nested, void function(Adapter adapter) callback)
    {
        // TODO : There's probably a better way.
        this.transaction(nested, callback.toDelegate);
    }

    abstract ulong update(EscapedString sql, string context);

    ulong update(EscapedString sql, Nullable!Variant[] parameters = []...)
    {
        return update(bind(sql, parameters), cast(string) null);
    }

    ulong update(EscapedString sql, string context, Nullable!Variant[] parameters = []...)
    {
        return update(bind(sql, parameters), context);
    }

    /++
     + Runs an UPDATE statement using a constructed SIRL query.
     ++/
    abstract ulong update(UpdateBuilder sirl, string context = null);
}
