
module siren.model.hydrate;

import siren.entity;
import siren.model.base;
import siren.util;

import std.typecons;
import std.variant;

void hydrate(E : Entity)(E entity, string[] fields, Nullable!Variant[] values)
{
    set(entity, fields, values);

    auto id = Model!E.getID(entity);

    if(!id.isNull && id.get.get!(IDType!E) != IDType!E.init)
    {
        foreach(field; getRelations!E)
        {
            // TODO : Get a mapping id.
            enum mapping = Model!E.tableName ~ "_id";
            auto relation = Model!(RelatedType!(E, field))
                .select(getColumnNames!(RelatedType!(E, field)))
                .where(mapping, id);

            __traits(getMember, entity, field) = RelationType!(E, field)(relation);
        }
    }
}
