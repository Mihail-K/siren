
module siren.sirl.node.is_null_node;

import siren.sirl.node.expression_node;
import siren.sirl.node.unary_node;
import siren.sirl.node_visitor;

import std.string;

enum IsNullOperator : string
{
    IsNull    = "IS NULL",
    IsNotNull = "IS NOT NULL"
}

class IsNullNode : UnaryNode
{
private:
    IsNullOperator _operator;

public:
    this(ExpressionNode operand, IsNullOperator operator)
    {
        super(operand);

        _operator = operator;
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    @property
    IsNullOperator operator()
    {
        return _operator;
    }

    override string toString()
    {
        return "IsNull(%s %s)".format(operand, operator);
    }
}
