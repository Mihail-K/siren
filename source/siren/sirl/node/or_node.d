
module siren.sirl.node.or_node;

import siren.sirl.node.binary_node;
import siren.sirl.node.expression_node;
import siren.sirl.node_visitor;

import std.string;

class OrNode : BinaryNode
{
    this(ExpressionNode left, ExpressionNode right)
    {
        super(left, right);
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    override string toString()
    {
        return "Or(%s %s)".format(left, right);
    }
}
