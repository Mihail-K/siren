
module siren.sirl.node.unary_node;

import siren.sirl.node.expression_node;

abstract class UnaryNode : ExpressionNode
{
private:
    ExpressionNode _operand;

public:
    this(ExpressionNode operand)
    {
        _operand = operand;
    }

    @property
    ExpressionNode operand()
    {
        return _operand;
    }
}
