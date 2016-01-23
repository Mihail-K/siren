
module siren.sirl.generator;

import siren.sirl.node_visitor;

abstract class Generator : NodeVisitor
{
    /++
     + Constructs an SQL string from the visited nodes.
     ++/
    @property
    string data();
}
