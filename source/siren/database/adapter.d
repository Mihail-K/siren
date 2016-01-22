
module siren.database.adapter;

import siren.database.insert_result;
import siren.database.query_result;
import siren.util.escaped_string;

import std.typecons;
import std.variant;

interface Adapter
{
    EscapedString bind(EscapedString sql, Nullable!Variant[] parameters...);

    bool close();

    bool commit();

    bool connect();

    @property
    bool connected();

    @property
    Object connection(); // TODO : Connection type.

    alias delete_ = destroy;

    ulong destroy(EscapedString sql, string context = null);

    ulong destroy(EscapedString sql, Nullable!Variant[] parameters...);

    ulong destroy(EscapedString sql, string context, Nullable!Variant[] parameters...);

    bool disconnect();

    EscapedString escape(string raw);

    ulong exec(EscapedString sql, string context = null);

    ulong exec(EscapedString sql, Nullable!Variant[] parameters...);

    ulong exec(EscapedString sql, string context, Nullable!Variant[] parameters...);

    InsertResult insert(EscapedString sql, string context = null);

    InsertResult insert(EscapedString sql, Nullable!Variant[] parameters...);

    InsertResult insert(EscapedString sql, string context, Nullable!Variant[] parameters...);

    @property
    string name();

    QueryResult query(EscapedString sql, string context = null);

    QueryResult query(EscapedString sql, Nullable!Variant[] parameters...);

    QueryResult query(EscapedString sql, string context, Nullable!Variant[] parameters...);

    bool reconnect();

    bool rollback();

    bool transaction();

    ulong update(EscapedString sql, string context = null);

    ulong update(EscapedString sql, Nullable!Variant[] parameters...);

    ulong update(EscapedString sql, string context, Nullable!Variant[] parameters...);
}
