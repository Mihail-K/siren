
module siren.sirl.select_builder;

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

    @property
    string table()
    {
        return _table;
    }
}
