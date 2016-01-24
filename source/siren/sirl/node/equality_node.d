
module siren.sirl.node.equality_node;

import siren.sirl.node.binary_node;
import siren.sirl.node.expression_node;
import siren.sirl.node_visitor;

import std.string;

enum EqualityOperator : string
{
    Equals    = "=",
    NotEquals = "!="
}

class EqualityNode : BinaryNode
{
private:
    EqualityOperator _operator;

public:
    this(ExpressionNode left, EqualityOperator operator, ExpressionNode right)
    {
        super(left, right);
        _operator = operator;
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    @property
    EqualityOperator operator()
    {
        return _operator;
    }

    override string toString()
    {
        return "Equality(%s %s %s)".format(left, operator, right);
    }
}
