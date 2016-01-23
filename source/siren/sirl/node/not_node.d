
module siren.sirl.node.not_node;

import siren.sirl.node.base;
import siren.sirl.node.unary_node;
import siren.sirl.node_visitor;

import std.string;

class NotNode : UnaryNode
{
    this(Node operand)
    {
        super(operand);
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    override string toString()
    {
        return "Not(%s)".format(operand);
    }
}
