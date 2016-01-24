
module siren.sirl.insert_builder;

import siren.sirl.node_visitor;
import siren.sirl.node;

class InsertBuilder
{
private:
    InsertNode _insert;
    string _table;

public:
    this(string table)
    {
        this(new TableNode(table));
    }

    this(TableNode table)
    {
        _insert = new InsertNode;
        _insert.table = table;
        _table = table.table;
    }

    InsertBuilder fields()(FieldNode[] fields)
    {
        _insert.fields = fields;

        return this;
    }

    InsertBuilder fields()(string[] fields)
    {
        auto result = fields.map!(f => FieldNode.create(_table, f)).array;

        return this.fields(result);
    }

    InsertBuilder fields(TList...)(TList fields)
    if(TList.length == 0)
    {
        return this.fields(null);
    }

    InsertBuilder fields(TList...)(TList fields)
    if(TList.length > 0)
    {
        auto mapped = new FieldNode[TList.length];

        foreach(index, field; fields)
        {
            mapped[index] = FieldNode.create(_table, field);
        }

        return this.fields(mapped);
    }

    InsertBuilder values()(ExpressionNode[] values)
    {
        if(_insert.values is null)
        {
            _insert.values = new ValuesNode(values);
        }
        else
        {
            _insert.values ~= values;
        }

        return this;
    }

    InsertBuilder values(TList...)(TList values)
    {
        auto expressions = new ExpressionNode[TList.length];

        foreach(index, value; values)
        {
            expressions[index] = LiteralNode.create(value);
        }

        return this.values(expressions);
    }

    @property
    string table()
    {
        return _table;
    }

    string toSql(NodeVisitor visitor)
    {
        visitor.visit(_insert);
        return visitor.data;
    }
}