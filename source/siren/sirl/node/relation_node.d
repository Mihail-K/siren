
module siren.sirl.node.relation_node;

import siren.sirl.node.binary_node;
import siren.sirl.node.expression_node;
import siren.sirl.node_visitor;

import std.string;

enum RelationOperator : string
{
    GreaterOrEqual = ">=",
    GreaterThan    = ">",
    LessOrEqual    = "<=",
    LessThan       = "<"
}

class RelationNode : BinaryNode
{
private:
    RelationOperator _operator;

public:
    this(ExpressionNode left, RelationOperator operator, ExpressionNode right)
    {
        super(left, right);
        _operator = operator;
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    @property
    RelationOperator operator()
    {
        return _operator;
    }

    override string toString()
    {
        return "Relation(%s %s %s)".format(left, operator, right);
    }
}
