
module siren.sirl.node.set_node;

import siren.sirl.node.assign_node;
import siren.sirl.node.base;
import siren.sirl.node_visitor;

import std.string;

class SetNode : Node
{
private:
    AssignNode[] _sets;

public:
    this(AssignNode[] sets = []...)
    {
        _sets = sets.dup;
    }

    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    void opOpAssign(string op : "~", T)(T sets)
    if(is(T : AssignNode) || is(T : AssignNode[]))
    {
        _sets ~= sets;
    }

    @property
    AssignNode[] sets()
    {
        return _sets;
    }

    @property
    void sets(AssignNode[] sets)
    {
        _sets = sets;
    }

    override string toString()
    {
        return "Set(%(%s, %))".format(sets);
    }
}
