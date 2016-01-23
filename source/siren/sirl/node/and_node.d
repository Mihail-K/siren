
module siren.sirl.node.and_node;

import siren.sirl.node.base;
import siren.sirl.node.binary_node;
import siren.sirl.node_visitor;

import std.string;

class AndNode : BinaryNode
{
    this(Node left, Node right)
    {
        super(left, right);
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    override string toString()
    {
        return "And(%s %s)".format(left, right);
    }
}
