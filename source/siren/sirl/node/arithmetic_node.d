
module siren.sirl.node.arithmetic_node;

import siren.sirl.node.binary_node;
import siren.sirl.node.expression_node;
import siren.sirl.node_visitor;

import std.string;

enum ArithmeticOperator
{
    Plus,
    Minus,
    Times,
    Divide,
    Modulo,
    ShiftLeft,
    ShiftRight,
    BitAnd,
    BitXor,
    BitOr
}

class ArithmeticNode : BinaryNode
{
private:
    ArithmeticOperator _operator;

public:
    this(ExpressionNode left, ArithmeticOperator operator, ExpressionNode right)
    {
        super(left, right);
        _operator = operator;
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    @property
    ArithmeticOperator operator()
    {
        return _operator;
    }

    override string toString()
    {
        return "Arithmetic(%s %s %s)".format(left, operator, right);
    }
}
