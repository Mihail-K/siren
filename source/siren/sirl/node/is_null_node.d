
module siren.sirl.node.is_null_node;

import siren.sirl.node.expression_node;
import siren.sirl.node_visitor;

import std.string;

class IsNullNode : ExpressionNode
{
private:
    static IsNullNode _null;
    static IsNullNode _notNull;

    bool _negated;

    static this()
    {
        _null = new IsNullNode(false);
        _notNull = new IsNullNode(true);
    }

    this(bool negated)
    {
        _negated = negated;
    }

public:
    static IsNullNode create(bool negated = false)
    {
        return negated ? _notNull : _null;
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    @property
    bool negated()
    {
        return _negated;
    }

    override string toString()
    {
        return "Is(%s)".format(_negated ? "Not Null" : "Null");
    }
}
