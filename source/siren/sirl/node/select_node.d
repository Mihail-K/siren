
module siren.sirl.node.select_node;

import siren.sirl.node.base;
import siren.sirl.node.limit_node;
import siren.sirl.node.offset_node;

class SelectNode : Node
{
private:
    LimitNode _limit;
    OffsetNode _offset;

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
}
