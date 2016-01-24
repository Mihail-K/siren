
module siren.sirl.node.values_node;

import siren.sirl.node.base;
import siren.sirl.node.expression_node;
import siren.sirl.node_visitor;

import std.string;

class ValuesNode : Node
{
private:
    ExpressionNode[] _values;

public:
    this(ExpressionNode[] values)
    {
        _values = values;
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    void opOpAssign(string op : "~", T)(T value)
    if(is(T : ExpressionNode) || is(T : ExpressionNode[]))
    {
        _values ~= values;
    }

    @property
    ExpressionNode[] values()
    {
        return _values;
    }

    @property
    void values(ExpressionNode[] values)
    {
        _values = values;
    }

    override string toString()
    {
        return "Values(%(%s, %))".format(values);
    }
}
