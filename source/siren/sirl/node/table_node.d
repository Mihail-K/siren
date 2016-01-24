
module siren.sirl.node.table_node;

import siren.sirl.node.base;
import siren.sirl.node_visitor;

import std.string;

class TableNode : Node
{
private:
    string _database;
    string _table;

public:
    this(string table)
    {
        _table = table;
    }

    this(string database, string table)
    {
        _database = database;
        _table = table;
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    @property
    final string database()
    {
        return _database;
    }

    @property
    final string table()
    {
        return _table;
    }

    override string toString()
    {
        return "Table(%s.%s)".format(_database, _table);
    }
}
