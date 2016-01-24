
module siren.sirl.node.expression_node;

import siren.sirl.node.and_node;
import siren.sirl.node.arithmetic_node;
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
        return IsNullNode.create;
    }

    @property
    ExpressionNode isNotNull()
    {
        return IsNullNode.create(true);
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

    ExpressionNode opBinary(string op : "+")(ExpressionNode node)
    {
        return new ArithmeticNode(this, ArithmeticOperator.Plus, node);
    }

    ExpressionNode opBinary(string op : "-")(ExpressionNode node)
    {
        return new ArithmeticNode(this, ArithmeticOperator.Minus, node);
    }

    ExpressionNode opBinary(string op : "*")(ExpressionNode node)
    {
        return new ArithmeticNode(this, ArithmeticOperator.Times, node);
    }

    ExpressionNode opBinary(string op : "/")(ExpressionNode node)
    {
        return new ArithmeticNode(this, ArithmeticOperator.Divide, node);
    }

    ExpressionNode opBinary(string op : "%")(ExpressionNode node)
    {
        return new ArithmeticNode(this, ArithmeticOperator.Modulo, node);
    }

    ExpressionNode opBinary(string op : "<<")(ExpressionNode node)
    {
        return new ArithmeticNode(this, ArithmeticOperator.ShiftLeft, node);
    }

    ExpressionNode opBinary(string op : ">>")(ExpressionNode node)
    {
        return new ArithmeticNode(this, ArithmeticOperator.ShiftRight, node);
    }

    ExpressionNode opBinary(string op : "&")(ExpressionNode node)
    {
        return new ArithmeticNode(this, ArithmeticOperator.BitAnd, node);
    }

    ExpressionNode opBinary(string op : "^")(ExpressionNode node)
    {
        return new ArithmeticNode(this, ArithmeticOperator.BitXor, node);
    }

    ExpressionNode opBinary(string op : "|")(ExpressionNode node)
    {
        return new ArithmeticNode(this, ArithmeticOperator.BitOr, node);
    }

    ExpressionNode or(ExpressionNode node)
    {
        return new OrNode(this, node);
    }
}
