
module siren.association.relation;

import siren.relation;

abstract class AssocativeRelation(O, S, string m) : Relation!S
{
protected:
    alias Owner   = O;
    alias Subject = S;
    enum  mapping = m;

private:
    Owner _owner;

public:
    this(Owner owner)
    {
        _owner = owner;

        super();
    }

    @property
    protected Owner owner()
    {
        return _owner;
    }
}
