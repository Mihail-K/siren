
module siren.sirl.node.expression_node;

import siren.sirl.node.and_node;
import siren.sirl.node.arithmetic_node;
import siren.sirl.node.base;
import siren.sirl.node.equality_node;
import siren.sirl.node.is_null_node;
import siren.sirl.node.literal_node;
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

    ExpressionNode eq(T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new EqualityNode(this, EqualityOperator.Equals, literal);
    }

    ExpressionNode ge(T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new RelationNode(this, RelationOperator.GreaterOrEqual, literal);
    }

    ExpressionNode gt(T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new RelationNode(this, RelationOperator.GreaterThan, literal);
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

    ExpressionNode le(T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new RelationNode(this, RelationOperator.LessOrEqual, literal);
    }

    ExpressionNode lt(T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new RelationNode(this, RelationOperator.LessThan, literal);
    }

    ExpressionNode ne(T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new EqualityNode(this, EqualityOperator.NotEquals, literal);
    }

    @property
    alias negate = not;

    @property
    ExpressionNode not()
    {
        return new NotNode(this);
    }

    ExpressionNode opBinary(string op : "+", T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new ArithmeticNode(this, ArithmeticOperator.Plus, literal);
    }

    ExpressionNode opBinary(string op : "-", T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new ArithmeticNode(this, ArithmeticOperator.Minus, literal);
    }

    ExpressionNode opBinary(string op : "*", T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new ArithmeticNode(this, ArithmeticOperator.Times, literal);
    }

    ExpressionNode opBinary(string op : "/", T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new ArithmeticNode(this, ArithmeticOperator.Divide, literal);
    }

    ExpressionNode opBinary(string op : "%", T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new ArithmeticNode(this, ArithmeticOperator.Modulo, literal);
    }

    ExpressionNode opBinary(string op : "<<", T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new ArithmeticNode(this, ArithmeticOperator.ShiftLeft, literal);
    }

    ExpressionNode opBinary(string op : ">>", T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new ArithmeticNode(this, ArithmeticOperator.ShiftRight, literal);
    }

    ExpressionNode opBinary(string op : "&", T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new ArithmeticNode(this, ArithmeticOperator.BitAnd, literal);
    }

    ExpressionNode opBinary(string op : "^", T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new ArithmeticNode(this, ArithmeticOperator.BitXor, literal);
    }

    ExpressionNode opBinary(string op : "|", T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new ArithmeticNode(this, ArithmeticOperator.BitOr, literal);
    }

    ExpressionNode opBinary(string op : "in", T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new InNode(this, InOperator.In, literal);
    }

    ExpressionNode opBinary(string op : "!in", T)(T node)
    if(!is(T : Node) || is(T : ExpressionNode))
    {
        auto literal = LiteralNode.create(node);
        return new InNode(this, InOperator.NotIn, literal);
    }

    ExpressionNode or(ExpressionNode node)
    {
        return new OrNode(this, node);
    }
}
