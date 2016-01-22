
module siren.sirl.node.select_node;

import siren.sirl.node.base;
import siren.sirl.node.field_node;
import siren.sirl.node.limit_node;
import siren.sirl.node.offset_node;

class SelectNode : Node
{
private:
    LimitNode _limit;
    OffsetNode _offset;
    FieldNode[] _projection;

public:
    @property
    LimitNode limit()
    {
        return _limit;
    }

    @property
    void limit(LimitNode limit)
    {
        _limit = limit;
    }

    @property
    OffsetNode offset()
    {
        return _offset;
    }

    @property
    void offset(OffsetNode offset)
    {
        _offset = offset;
    }

    @property
    FieldNode[] projection()
    {
        return _projection;
    }

    @property
    void projection(FieldNode[] projection)
    {
        _projection = projection;
    }
}
