
module siren.sirl.node.literal_node;

import siren.sirl.node.base;
import siren.sirl.node.expression_node;
import siren.sirl.node_visitor;

import std.string;
import std.variant;

class LiteralNode : ExpressionNode
{
private:
    Variant _value;

public:
    this(Variant value)
    {
        _value = value;
    }

    static LiteralNode create(T)(T value)
    if(!is(T : Node))
    {
        return new LiteralNode(Variant(value));
    }

    static T create(T)(T value)
    if(is(T : Node))
    {
        return value;
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    @property
    Variant value()
    {
        return _value;
    }

    override string toString()
    {
        return "Literal(%s)".format(_value);
    }
}
