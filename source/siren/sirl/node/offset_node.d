
module siren.sirl.node.offset_node;

import std.string;

class OffsetNode : Node
{
private:
    ulong _offset;

public:
    this(ulong offset)
    {
        _offset = offset;
    }

    static OffsetNode create(T : OffsetNode)(T offset)
    {
        return offset;
    }

    static OffsetNode create(T : ulong)(T offset)
    {
        return new OffsetNode(offset);
    }

    static OffsetNode create(T : string)(T offset)
    {
        return new OffsetNode(offset.to!ulong);
    }

    static OffsetNode create(T : typeof(null))(T offset)
    {
        return null;
    }

    @property
    ulong offset()
    {
        return _offset;
    }

    override string toString()
    {
        return "Offset(%s)".format(_offset);
    }
}
