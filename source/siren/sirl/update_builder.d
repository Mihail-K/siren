
module siren.sirl.update_builder;

import siren.sirl.node_visitor;
import siren.sirl.node;

class UpdateBuilder
{
private:
    string _table;
    UpdateNode _update;

public:
    this(string table)
    {
        this(new TableNode(table));
    }

    this(TableNode table)
    {
        _update = new UpdateNode;
        _update.table = table;
        _table = table.table;
    }

    UpdateBuilder set(T)(T sets)
    if(is(T : AssignNode) || is(T : AssignNode[]))
    {
        if(_update.set is null)
        {
            _update.set = new SetNode(sets);
        }
        else
        {
            _update.set ~= sets;
        }

        return this;
    }

    UpdateBuilder set()(FieldNode left, ExpressionNode right)
    {
        return this.set(left = right);
    }

    UpdateBuilder set(T, V)(T field, V value)
    {
        auto left = FieldNode.create(_table, field);
        auto right = LiteralNode.create(value);

        return this.set(left, right);
    }

    @property
    string table()
    {
        return _table;
    }

    UpdateBuilder where(T)(T clauses)
    if(is(T : ExpressionNode) || is(T : ExpressionNode[]))
    {
        if(_update.where is null)
        {
            _update.where = new WhereNode(clauses);
        }
        else
        {
            _update.where ~= clauses;
        }

        return this;
    }

    UpdateBuilder where()(FieldNode left, ExpressionNode right)
    {
        return this.where(left.eq(right));
    }

    UpdateBuilder where(T, V)(T field, V value)
    {
        auto left = FieldNode.create(_table, field);
        auto right = LiteralNode.create(value);

        return this.where(left, right);
    }
}
