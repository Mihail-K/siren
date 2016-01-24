
module siren.sirl.node.field_node;

import siren.sirl.node.expression_node;
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
