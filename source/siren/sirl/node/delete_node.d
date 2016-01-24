
module siren.sirl.node.delete_node;

import siren.sirl.node.base;
import siren.sirl.node.table_node;
import siren.sirl.node.where_node;
import siren.sirl.node_visitor;

class DeleteNode : Node
{
private:
    TableNode _table;
    WhereNode _where;

public:
    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
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
