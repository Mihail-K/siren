
module siren.sirl.generator;

import siren.sirl.node;

abstract class Generator : NodeVisitor
{
    /++
     + Constructs an SQL string from the visited nodes.
     ++/
    @property
    string data();
}
