
module siren.sirl.select_builder;

import siren.sirl.node;

class SelectBuilder
{
private:
    SelectNode _select;
    string _table;

public:
    this(string table)
    {
        _select = new SelectNode;
        _table = table;
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

    SelectBuilder projection(TList...)(TList projection)
    if(TList.length == 0)
    {
        return projection(null);
    }

    SelectBuilder projection(TList...)(TList projection)
    if(TList.length > 0)
    {
        auto fields = new FieldNode[TList.length];

        foreach(index, field; projection)
        {
            fields[index] = FieldNode.create(_table, field);
        }

        _select.projection = fields;

        return this;
    }

    @property
    string table()
    {
        return _table;
    }
}
