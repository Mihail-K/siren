
module siren.sirl.node.expression_node;

import siren.sirl.node.and_node;
import siren.sirl.node.base;
import siren.sirl.node.is_null_node;
import siren.sirl.node.not_node;
import siren.sirl.node.or_node;
import siren.sirl.node.relation_node;

/++
 + Represents an AST node that can be part of an expression.
 ++/
abstract class ExpressionNode : Node
{
    ExpressionNode and(ExpressionNode node)
    {
        return new AndNode(this, node);
    }

    ExpressionNode ge(ExpressionNode node)
    {
        return new RelationNode(this, RelationOperator.GreaterOrEqual, node);
    }

    ExpressionNode gt(ExpressionNode node)
    {
        return new RelationNode(this, RelationOperator.GreaterThan, node);
    }

    @property
    ExpressionNode isNull()
    {
        return IsNullNode.NULL;
    }

    @property
    ExpressionNode isNotNull()
    {
        return IsNullNode.NOT_NULL;
    }

    ExpressionNode le(ExpressionNode node)
    {
        return new RelationNode(this, RelationOperator.LessOrEqual, node);
    }

    ExpressionNode lt(ExpressionNode node)
    {
        return new RelationNode(this, RelationOperator.LessThan, node);
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
