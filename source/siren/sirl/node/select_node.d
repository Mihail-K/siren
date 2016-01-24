
module siren.sirl.node.select_node;

import siren.sirl.node.base;
import siren.sirl.node.field_node;
import siren.sirl.node.limit_node;
import siren.sirl.node.offset_node;
import siren.sirl.node.order_node;
import siren.sirl.node.table_node;
import siren.sirl.node.where_node;
import siren.sirl.node_visitor;

class SelectNode : Node
{
private:
    LimitNode _limit;
    OffsetNode _offset;
    OrderNode[] _orders;
    FieldNode[] _projection;
    TableNode _table;
    WhereNode _where;

public:
    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    @property
    LimitNode limit()
    {
        return _limit;
    }

    @property
    void limit(LimitNode limit)
    {
        _limit = limit;
    }

    @property
    OffsetNode offset()
    {
        return _offset;
    }

    @property
    void offset(OffsetNode offset)
    {
        _offset = offset;
    }

    @property
    OrderNode[] orders()
    {
        return _orders;
    }

    @property
    void orders(OrderNode[] orders)
    {
        _orders = orders;
    }

    @property
    FieldNode[] projection()
    {
        return _projection;
    }

    @property
    void projection(FieldNode[] projection)
    {
        _projection = projection;
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
