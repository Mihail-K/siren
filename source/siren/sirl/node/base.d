
module siren.sirl.node.base;

import siren.sirl.node.node_visitor;

abstract class Node
{
    abstract void accept(NodeVisitor visitor);
}
