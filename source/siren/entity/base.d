
module siren.entity.base;

import siren.schema;
import siren.util;

import std.algorithm;
import std.array;
import std.meta;
import std.string;

mixin template Entity(string module_ = "schema")
{
    import siren.database;
    import siren.entity.associations;
    import siren.entity.attributes;
    import siren.entity.callbacks;
    import siren.entity.hydrates;
    import siren.sirl;

    mixin Attributes!module_;
    mixin Associations;
    mixin Callbacks;
    mixin Hydrates;

private:
    static Adapter _adapter;
    static Query _query;

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

    @property
    static Query query()
    {
        if(_query is null)
        {
            // Use lazy initialization.
            _query = new Query(typeof(this).table);
        }

        return _query;
    }

    /++
     + Forwards to the Entity's adapter's transaction function.
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
}

template isEntity(E)
{
    enum isEntity =
        is(typeof(__traits(getMember, E, "schemaDefinition")) == SchemaDefinition) &&
        is(typeof(__traits(getMember, E, "tableDefinition")) == TableDefinition) &&
        is(typeof(__traits(getMember, E, "table")) : string);
}
