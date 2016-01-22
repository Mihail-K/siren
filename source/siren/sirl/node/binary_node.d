
module siren.sirl.node.binary_node;

abstract class BinaryNode : Node
{
private:
    Node _left;
    Node _right;

public:
    this(Node left, Node right)
    {
        _left = left;
        _right = right;
    }

    @property
    Node left()
    {
        return _left;
    }

    @property
    Node right()
    {
        return _right;
    }
}
