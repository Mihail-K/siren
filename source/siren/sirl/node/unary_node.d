
module siren.sirl.node.unary_node;

import siren.sirl.node.base;

abstract class UnaryNode : Node
{
private:
    Node _operand;

public:
    this(Node operand)
    {
        _operand = operand;
    }

    @property
    Node operand()
    {
        return _operand;
    }
}
