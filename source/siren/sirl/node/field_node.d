
module siren.sirl.node.field_node;

import siren.sirl.node.assign_node;
import siren.sirl.node.base;
import siren.sirl.node.expression_node;
import siren.sirl.node.literal_node;
import siren.sirl.node_visitor;

import std.string;

class FieldNode : ExpressionNode
{
private:
    string _field;
    string _table;

public:
    this(string table, string field)
    {
        _table = table;
        _field = field;
    }

    static FieldNode create(string table, FieldNode field)
    {
        return field;
    }

    static FieldNode create(string table, string field)
    {
        return new FieldNode(table, field);
    }

    static FieldNode create(string table, typeof(null) field)
    {
        return new FieldNode(table, field);
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    @property
    string field()
    {
        return _field ? _field : "*";
    }

    AssignNode opAssign(T)(T node)
    if(!is(T : Node) || (is(T : ExpressionNode) && !is(T : FieldNode)))
    {
        auto literal = LiteralNode.create(node);
        return new AssignNode(this, literal);
    }

    @property
    string table()
    {
        return _table;
    }

    override string toString()
    {
        return "Field(%s.%s)".format(_table, field);
    }
}
