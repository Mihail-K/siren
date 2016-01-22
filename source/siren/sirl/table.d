
module siren.sirl.table;

import siren.sirl.node;

class Table
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

    alias SelectBuilder = Object; // TODO

    @property
    SelectBuilder select()
    {
        return new SelectBuilder;
    }

    alias UpdateBuilder = Object; // TODO

    @property
    UpdateBuilder update()
    {
        return new UpdateBuilder;
    }
}
