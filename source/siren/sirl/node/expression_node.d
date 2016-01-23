
module siren.sirl.node.expression_node;

import siren.sirl.node.and_node;
import siren.sirl.node.base;
import siren.sirl.node.not_node;
import siren.sirl.node.or_node;

/++
 + Represents an AST node that can be part of an expression.
 ++/
abstract class ExpressionNode : Node
{
    ExpressionNode and(ExpressionNode node)
    {
        return new AndNode(this, node);
    }

    alias negate = not;

    ExpressionNode not()
    {
        return new NotNode(this);
    }

    ExpressionNode or(ExpressionNode node)
    {
        return new OrNode(this, node);
    }
}
