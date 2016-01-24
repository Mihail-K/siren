
module siren.sirl.node.assign_node;

import siren.sirl.node.binary_node;
import siren.sirl.node.expression_node;
import siren.sirl.node_visitor;

import std.string;

class AssignNode : BinaryNode
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
        return "Assign(%s = %s)".format(left, right);
    }
}
