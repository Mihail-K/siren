
module siren.sirl.insert_builder;

import siren.sirl.generator;
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

    string toSql(Generator generator)
    {
        generator.visit(_insert);
        return generator.data;
    }
}
