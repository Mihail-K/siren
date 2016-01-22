
module siren.sirl.node.limit_node;

import std.conv;
import std.string;

class LimitNode : Node
{
private:
    ulong _limit;

public:
    this(ulong limit)
    {
        _limit = limit;
    }

    static LimitNode create(T : LimitNode)(T limit)
    {
        return limit;
    }

    static LimitNode create(T : ulong)(T limit)
    {
        return new LimitNode(limit);
    }

    static LimitNode create(T : string)(T limit)
    {
        return new LimitNode(limit.to!ulong);
    }

    static LimitNode create(T : typeof(null))(T limit)
    {
        return null;
    }

    @property
    ulong limit()
    {
        return _limit;
    }

    override string toString()
    {
        return "Limit(%s)".format(_limit);
    }
}
