
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

    string toSql(NodeVisitor visitor)
    {
        visitor.visit(_insert);
        return visitor.data;
    }
}
