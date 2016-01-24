
module siren.sirl.node.is_null_node;

import siren.sirl.node.expression_node;
import siren.sirl.node_visitor;

class IsNullNode : ExpressionNode
{
    override void accept(NodeVisitor visitor)
    {
        visitor.visit(this);
    }

    override string toString()
    {
        return "Is(Null)";
    }
}
