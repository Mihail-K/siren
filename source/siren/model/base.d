
module siren.model.base;

import siren.database;
import siren.entity;
import siren.sirl;

class Model(E : Entity)
{
private:
    static Adapter _adapter;
    static Query _table;

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

    static E find(IDType!E id)
    {
        auto query = table.select
            .projection(getColumnNames!E)
            .where(getIDColumnName!E, id)
            .limit(1);

        return null;
    }

    @property
    static Query table()
    {
        if(_table is null)
        {
            // Use lazy initialization.
            _table = new Query(getTableName!E);
        }

        return _table;
    }
}
