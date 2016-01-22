
module siren.sirl.node.arithmetic_node;

import siren.sirl.node.base;
import siren.sirl.node.binary_node;

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
    this(Node left, ArithmeticOperator operator, Node right)
    {
        super(left, right);
        _operator = operator;
    }

    @property
    ArithmeticOperator operator()
    {
        return _operator;
    }
}
