
module siren.sirl.node.update_node;

import siren.sirl.node.base;
import siren.sirl.node.set_node;
import siren.sirl.node.table_node;
import siren.sirl.node.where_node;
import siren.sirl.node_visitor;

class UpdateNode : Node
{
private:
    SetNode _set;
    TableNode _table;
    WhereNode _where;

public:
    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    @property
    SetNode set()
    {
        return _set;
    }

    @property
    void set(SetNode set)
    {
        _set = set;
    }

    @property
    TableNode table()
    {
        return _table;
    }

    @property
    void table(TableNode table)
    {
        _table = table;
    }

    @property
    WhereNode where()
    {
        return _where;
    }

    @property
    void where(WhereNode where)
    {
        _where = where;
    }
}
