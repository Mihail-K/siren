
module siren.model.base;

import siren.entity;
import siren.sirl;

class Model(E : Entity)
{
private:
    static Query _table;

    static this()
    {
        _table = new Query(getTableName!E);
    }

public:
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
        return _table;
    }
}
