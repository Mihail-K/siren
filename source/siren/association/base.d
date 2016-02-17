
module siren.association.base;

import siren.association.has_many;
import siren.association.has_one;
import siren.association.owned_by;

import std.traits;

template isAssociation(Type)
{
    static if(__traits(compiles, TemplateOf!Type))
    {
        enum isAssociation = __traits(isSame, TemplateOf!Type, HasOne) ||
                             __traits(isSame, TemplateOf!Type, HasMany) ||
                             __traits(isSame, TemplateOf!Type, OwnedBy);
    }
    else
    {
        enum isAssociation = false;
    }
}

template AssociationType(Type)
if(isAssociation!Type)
{
    alias AssociationType = TemplateOf!Type;
}

template AssociatedType(Type)
if(isAssociation!Type)
{
    alias AssociatedType = TemplateArgsOf!Type[0];
}
