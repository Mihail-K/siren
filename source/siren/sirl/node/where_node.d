
module siren.sirl.node.where_node;

import siren.sirl.node.base;
import siren.sirl.node.expression_node;
import siren.sirl.node_visitor;

import std.string;

class WhereNode : Node
{
private:
    ExpressionNode[] _clauses;

public:
    this(ExpressionNode[] clauses = []...)
    {
        _clauses = clauses;
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    @property
    ref ExpressionNode[] clauses()
    {
        return _clauses;
    }

    @property
    void clauses(ExpressionNode[] clauses)
    {
        _clauses = clauses;
    }

    override string toString()
    {
        return "Where(%(%s%| AND %))".format(_clauses);
    }
}
