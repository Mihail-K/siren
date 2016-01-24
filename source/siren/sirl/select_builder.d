
module siren.sirl.select_builder;

import siren.sirl.node_visitor;
import siren.sirl.node;

import std.algorithm;
import std.array;

class SelectBuilder
{
private:
    SelectNode _select;
    string _table;

public:
    this(string table)
    {
        this(new TableNode(table));
    }

    this(TableNode table)
    {
        _select = new SelectNode;
        _select.table = table;
        _table = table.table;
    }

    SelectBuilder limit(T)(T limit)
    {
        _select.limit = LimitNode.create(limit);

        return this;
    }

    SelectBuilder offset(T)(T offset)
    {
        _select.offset = OffsetNode.create(offset);

        return this;
    }

    SelectBuilder order(T, D : string)(T field, D direction = "asc")
    {
        auto order = OrderNode.create(FieldNode.create(_table, field), direction);
        _select.orders = _select.orders ~ order;

        return this;
    }

    SelectBuilder order(T, D : OrderDirection)(T field, D direction = OrderDirection.Asc)
    {
        auto order = OrderNode.create(FieldNode.create(_table, field), direction);
        _select.orders = _select.orders ~ order;

        return this;
    }

    SelectBuilder projection()(FieldNode[] projection)
    {
        _select.projection = projection;

        return this;
    }

    SelectBuilder projection()(string[] projection)
    {
        auto fields = projection.map!(p => FieldNode.create(_table, p)).array;

        return this.projection(fields);
    }

    SelectBuilder projection(TList...)(TList projection)
    if(TList.length == 0)
    {
        return this.projection(null);
    }

    SelectBuilder projection(TList...)(TList projection)
    if(TList.length > 0)
    {
        auto fields = new FieldNode[TList.length];

        foreach(index, field; projection)
        {
            fields[index] = FieldNode.create(_table, field);
        }

        return this.projection(fields);
    }

    SelectBuilder reorder()()
    {
        _select.orders = [ ];

        return this;
    }

    SelectBuilder reorder(T, D : string)(T field, D direction = "asc")
    {
        auto order = OrderNode.create(FieldNode.create(_table, field), direction);
        _select.orders = [ order ];

        return this;
    }

    SelectBuilder reorder(T, D : OrderDirection)(T field, D direction = OrderDirection.Asc)
    {
        auto order = OrderNode.create(FieldNode.create(_table, field), direction);
        _select.orders = [ order ];

        return this;
    }

    SelectBuilder where()(ExpressionNode clause)
    {
        if(_select.where is null)
        {
            _select.where = new WhereNode;
        }

        _select.where.clauses ~= clause;

        return this;
    }

    SelectBuilder where()(FieldNode left, ExpressionNode right)
    {
        return this.where(left.eq(right));
    }

    SelectBuilder where(T, V)(T field, V value)
    {
        auto left = FieldNode.create(_table, field);
        auto right = LiteralNode.create(value);

        return this.where(left, right);
    }

    @property
    string table()
    {
        return _table;
    }

    string toSql(NodeVisitor visitor)
    {
        visitor.visit(_select);
        return visitor.data;
    }
}
