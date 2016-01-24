
module siren.sirl.query;

import siren.sirl.node;
import siren.sirl.insert_builder;
import siren.sirl.select_builder;
import siren.sirl.update_builder;

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

    AssignNode opIndexAssign(ExpressionNode node, string field)
    {
        return new AssignNode(this[field], node);
    }

    @property
    InsertBuilder insert()
    {
        return new InsertBuilder(_table);
    }

    @property
    SelectBuilder select()
    {
        return new SelectBuilder(_table);
    }

    @property
    UpdateBuilder update()
    {
        return new UpdateBuilder(_table);
    }
}
