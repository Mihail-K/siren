
module siren.sirl.node.offset_node;

import siren.sirl.node.base;
import siren.sirl.node.node_visitor;

import std.conv;
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

    static OffsetNode create(OffsetNode offset)
    {
        return offset;
    }

    static OffsetNode create(ulong offset)
    {
        return new OffsetNode(offset);
    }

    static OffsetNode create(string offset)
    {
        return new OffsetNode(offset.to!ulong);
    }

    static OffsetNode create(typeof(null) offset)
    {
        return null;
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
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
