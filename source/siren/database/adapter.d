
module siren.database.adapter;

import siren.database.insert_result;
import siren.database.query_result;
import siren.sirl;
import siren.util;

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

    @property
    abstract void connected();

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
    void hook(scope void function(bool success) callback);

    /++
     + Adds a hook delegate to be executed once the current transaction ends.
     ++/
    void hook(scope void delegate(bool success) callback);

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
     + Runs a SELECT statement using a SIRL constructed query.
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

    abstract ulong update(EscapedString sql, string context);

    ulong update(EscapedString sql, Nullable!Variant[] parameters = []...)
    {
        return update(bind(sql, parameters), cast(string) null);
    }

    ulong update(EscapedString sql, string context, Nullable!Variant[] parameters = []...)
    {
        return update(bind(sql, parameters), context);
    }
}
