
module siren.sirl.node.insert_node;

import siren.sirl.node.base;
import siren.sirl.node.table_node;
import siren.sirl.node.values_node;
import siren.sirl.node_visitor;

class InsertNode : Node
{
private:
    TableNode _table;
    ValuesNode _values;

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
    ValuesNode values()
    {
        return _values;
    }

    @property
    void values(ValuesNode values)
    {
        _values = values;
    }
}
