
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

    string toSql(NodeVisitor visitor)
    {
        visitor.visit(_insert);
        return visitor.data;
    }
}
