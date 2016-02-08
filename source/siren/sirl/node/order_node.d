
module siren.sirl.node.order_node;

import siren.sirl.node.base;
import siren.sirl.node.field_node;
import siren.sirl.node_visitor;

import std.exception;
import std.string;

enum OrderDirection : string
{
    Asc  = "ASC",
    Desc = "DESC"
}

private OrderDirection fromName(string name)
{
    switch(name.toLower)
    {
        case "asc":
            return OrderDirection.Asc;
        case "desc":
            return OrderDirection.Desc;
        default:
            assert(0, "No orderable direction `" ~ name ~ "`");
    }
}

class OrderNode : Node
{
private:
    OrderDirection _direction;
    FieldNode _field;

public:
    this(FieldNode field, OrderDirection direction)
    {
        _direction = direction;
        _field = field;
    }

    static OrderNode create(FieldNode field, OrderDirection direction)
    {
        return new OrderNode(field, direction);
    }

    static OrderNode create(FieldNode field, string direction)
    {
        return new OrderNode(field, direction.fromName);
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    @property
    OrderDirection direction()
    {
        return _direction;
    }

    @property
    FieldNode field()
    {
        return _field;
    }

    override string toString()
    {
        return "Order(%s : %s)".format(_field, _direction);
    }
}
