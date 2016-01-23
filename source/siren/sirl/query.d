
module siren.sirl.query;

import siren.sirl.node;
import siren.sirl.select_builder;

class Query
{
private:
    string _table;

public:
    this(string table)
    {
        _table = table;
    }

    alias DeleteBuilder = Object; // TODO

    @property
    DeleteBuilder destroy()
    {
        return new DeleteBuilder;
    }

    FieldNode opIndex(string field)
    {
        return new FieldNode(_table, field);
    }

    alias InsertBuilder = Object; // TODO

    @property
    InsertBuilder insert()
    {
        return new InsertBuilder;
    }

    @property
    SelectBuilder select()
    {
        return new SelectBuilder(_table);
    }

    alias UpdateBuilder = Object; // TODO

    @property
    UpdateBuilder update()
    {
        return new UpdateBuilder;
    }
}
