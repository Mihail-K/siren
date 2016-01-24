
module siren.sirl.node.in_node;

import siren.sirl.node.binary_node;
import siren.sirl.node.expression_node;
import siren.sirl.node_visitor;

import std.string;

enum InOperator : string
{
    In    = "IN",
    NotIn = "NOT IN"
}

class InNode : BinaryNode
{
private:
    InOperator _operator;

public:
    this(ExpressionNode left, InOperator operator, ExpressionNode right)
    {
        super(left, right);
        _operator = operator;
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    @property
    InOperator operator()
    {
        return _operator;
    }

    override string toString()
    {
        return "In(%s %s %s)".format(left, operator, right);
    }
}
