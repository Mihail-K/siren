
module siren.sirl.update_builder;

import siren.sirl.node;

import std.exception;
import std.range;
import std.typecons;
import std.variant;

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

    @property
    UpdateNode node()
    {
        return _update;
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

    UpdateBuilder set()(string[] fields, Nullable!Variant[] values)
    {
        enforce(fields.length == values.length, "Parameter count mismatch.");
        auto sets = new AssignNode[fields.length];

        foreach(index, field, value; fields.lockstep(values))
        {
            auto left = FieldNode.create(_table, field);
            auto right = LiteralNode.create(value);

            sets[index] = AssignNode.create(left, right);
        }

        return this.set(sets);
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
