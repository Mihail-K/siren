
module siren.sirl.node.select_node;

import siren.sirl.node.base;
import siren.sirl.node.field_node;
import siren.sirl.node.limit_node;
import siren.sirl.node.node_visitor;
import siren.sirl.node.offset_node;
import siren.sirl.node.order_node;

class SelectNode : Node
{
private:
    LimitNode _limit;
    OffsetNode _offset;
    OrderNode[] _orders;
    FieldNode[] _projection;

public:
    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);

        foreach(field; _projection)
        {
            visitor.visit(field);
        }

        foreach(order; _orders)
        {
            visitor.visit(order);
        }

        if(_limit !is null)
        {
            visitor.visit(_limit);
        }

        if(_offset !is null)
        {
            visitor.visit(_offset);
        }
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
}
