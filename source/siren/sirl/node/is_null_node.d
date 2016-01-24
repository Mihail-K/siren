
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
    @property
    static IsNullNode NULL()
    {
        return _null;
    }

    @property
    static IsNullNode NOT_NULL()
    {
        return _notNull;
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
