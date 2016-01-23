
module siren.sirl.node_visitor;

import siren.sirl.node;

interface NodeVisitor
{
    void visit(AndNode node);

    void visit(ArithmeticNode node);

    void visit(FieldNode node);

    void visit(LimitNode node);

    void visit(OffsetNode node);

    void visit(OrNode node);

    void visit(OrderNode node);

    void visit(SelectNode node);
}
