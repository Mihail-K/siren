
module siren.sirl.delete_builder;

import siren.sirl.node_visitor;
import siren.sirl.node;

class DeleteBuilder
{
private:
    DeleteNode _delete;
    string _table;

public:
    this(string table)
    {
        this(new TableNode(table));
    }

    this(TableNode table)
    {
        _delete = new DeleteNode;
        _delete.table = table;
        _table = table.table;
    }

    @property
    string table()
    {
        return table;
    }

    string toSql(NodeVisitor visitor)
    {
        visitor.visit(_delete);
        return visitor.data;
    }

    DeleteBuilder where(T)(T clauses)
    if(is(T : ExpressionNode) || is(T : ExpressionNode[]))
    {
        if(_delete.where is null)
        {
            _delete.where = new WhereNode(clauses);
        }
        else
        {
            _delete.where ~= clauses;
        }

        return this;
    }

    DeleteBuilder where()(FieldNode left, ExpressionNode right)
    {
        return this.where(left.eq(right));
    }

    DeleteBuilder where(T, V)(T field, V value)
    {
        auto left = FieldNode.create(_table, field);
        auto right = LiteralNode.create(value);

        return this.where(left, right);
    }
}
