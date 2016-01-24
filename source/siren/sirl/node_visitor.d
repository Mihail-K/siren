
module siren.sirl.node_visitor;

import siren.sirl.node;

interface NodeVisitor
{
    @property
    string data();

    void visit(AndNode node);

    void visit(ArithmeticNode node);

    void visit(EqualityNode node);

    void visit(FieldNode node);

    void visit(InNode node);

    void visit(InsertNode node);

    void visit(IsNullNode node);

    void visit(LimitNode node);

    void visit(LiteralNode node);

    void visit(NotNode node);

    void visit(OffsetNode node);

    void visit(OrNode node);

    void visit(OrderNode node);

    void visit(RelationNode node);

    void visit(SelectNode node);

    void visit(TableNode node);

    void visit(WhereNode node);
}
