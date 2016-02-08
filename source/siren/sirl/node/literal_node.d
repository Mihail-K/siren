
module siren.sirl.node.literal_node;

import siren.sirl.node.base;
import siren.sirl.node.expression_node;
import siren.sirl.node_visitor;
import siren.util.types;

import std.string;
import std.typecons;
import std.variant;

class LiteralNode : ExpressionNode
{
private:
    Nullable!Variant _value;

public:
    this()
    {
    }

    this(Nullable!Variant value)
    {
        _value = value;
    }

    static LiteralNode create(T)(T value)
    if(!is(T : Node) && isNullAssignable!T)
    {
        Nullable!Variant v;

        if(value !is null)
        {
            v = Variant(value);
        }

        return new LiteralNode(v);
    }

    static LiteralNode create(T)(T value)
    if(!is(T : Node) && isNullableWrapped!T)
    {
        Nullable!Variant v;

        if(!value.isNull)
        {
            v = Variant(value.get);
        }

        return new LiteralNode(v);
    }

    static LiteralNode create(T)(T value)
    if(!is(T : Node) && !isNullAssignable!T && !isNullableWrapped!T)
    {
        Nullable!Variant v = Variant(value);
        return new LiteralNode(v);
    }

    static LiteralNode create()(typeof(null) value)
    {
        return new LiteralNode;
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
    Nullable!Variant value()
    {
        return _value;
    }

    override string toString()
    {
        return "Literal(%s)".format(_value);
    }
}
