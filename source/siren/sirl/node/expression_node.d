
module siren.sirl.node.expression_node;

import siren.sirl.node.and_node;
import siren.sirl.node.base;
import siren.sirl.node.is_null_node;
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

    @property
    ExpressionNode isNull()
    {
        // TODO : Use a singleton.
        return new IsNullNode();
    }

    @property
    ExpressionNode isNotNull()
    {
        return isNull.negate;
    }

    @property
    alias negate = not;

    @property
    ExpressionNode not()
    {
        return new NotNode(this);
    }

    ExpressionNode or(ExpressionNode node)
    {
        return new OrNode(this, node);
    }
}
