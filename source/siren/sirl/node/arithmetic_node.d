
module siren.sirl.node.arithmetic_node;

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
    this(ArithmeticOperator operator)
    {
        _operator = operator;
    }

    @property
    string operator()
    {
        return _operator;
    }
}
