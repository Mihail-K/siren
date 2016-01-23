
module siren.sirl.node.binary_node;

import siren.sirl.node.expression_node;

abstract class BinaryNode : ExpressionNode
{
private:
    ExpressionNode _left;
    ExpressionNode _right;

public:
    this(ExpressionNode left, ExpressionNode right)
    {
        _left = left;
        _right = right;
    }

    @property
    ExpressionNode left()
    {
        return _left;
    }

    @property
    ExpressionNode right()
    {
        return _right;
    }
}
