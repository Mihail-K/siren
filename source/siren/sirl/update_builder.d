
module siren.sirl.update_builder;

import siren.sirl.node_visitor;
import siren.sirl.node;

class UpdateBuilder
{
private:
    string _table;
    UpdateNode _update;

public:
    this(string table)
    {
        this(new TableNode(table));
    }

    this(TableNode table)
    {
        _update = new UpdateNode;
        _update.table = table;
        _table = table.table;
    }

    @property
    string table()
    {
        return _table;
    }
}
