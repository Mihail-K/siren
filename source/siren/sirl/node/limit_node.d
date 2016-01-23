
module siren.sirl.node.limit_node;

import siren.sirl.node.base;
import siren.sirl.node_visitor;

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

    static LimitNode create(LimitNode limit)
    {
        return limit;
    }

    static LimitNode create(ulong limit)
    {
        return new LimitNode(limit);
    }

    static LimitNode create(string limit)
    {
        return new LimitNode(limit.to!ulong);
    }

    static LimitNode create(typeof(null) limit)
    {
        return null;
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
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
