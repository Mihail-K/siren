
module siren.entity.base;

mixin template Entity()
{
    import siren.database;
    import siren.entity;
    import siren.relation;
    import siren.sirl;

    mixin Schema;
    mixin Attributes;
    mixin Construction;
    mixin Associations;
    mixin Callbacks;
    mixin Relations;
    mixin Transactions;
    mixin Persistence;

    /++
     + The default name of the module from which the schema is loaded.
     ++/
    @property
    enum string schemaModule = "schema";

private:
    static Adapter _adapter;

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
}
