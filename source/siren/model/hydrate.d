
module siren.model.hydrate;

import siren.entity;
import siren.model.base;
import siren.util;

import std.typecons;
import std.variant;

void hydrate(E)(E entity, string[] fields, Nullable!Variant[] values)
{
    set(entity, fields, values);

    foreach(field; getRelations!E)
    {
        alias Relationship = RelationshipType!(E, field);

        static if(__traits(isSame, Relationship, HasOne))
        {
            hydrateOwningRelation!(E, field)(entity);
        }
        else static if(__traits(isSame, Relationship, HasMany))
        {
            hydrateOwningRelation!(E, field)(entity);
        }
        else static if(__traits(isSame, Relationship, OwnedBy))
        {
            hydrateOwnedByRelation!(E, field)(entity);
        }
    }
}

void hydrateOwningRelation(E, string field)(E entity)
{
    alias Owned = RelatedType!(E, field);

    static if(hasMapping!(E, field))
    {
        // Mapping is defined by attribute.
        enum mapping = getMappingColumn!(E, field);
    }
    else
    {
        // Mapping is defined by ID column name.
        enum mapping = getDefaultMappingColumn!E;
    }

    // Ensure the mapping column is present on the owned entity.
    static assert(hasColumn!(Owned, mapping), "Entity `" ~ Owned.stringof ~ "` doesn't have column `" ~ mapping ~ "`.");

    auto relation = Model!Owned
        .select(getColumnNames!Owned)
        .where(mapping, Model!E.getID(entity));

    __traits(getMember, entity, field) = RelationType!(E, field)(relation);
}

void hydrateOwnedByRelation(E, string field)(E entity)
{
    alias Owner = RelatedType!(E, field);

    static if(hasMapping!(E, field))
    {
        // Mapping is defined by attribute.
        enum mapping = getMappingColumn!(E, field);
    }
    else
    {
        // Mapping is defined by owner's ID column name.
        enum mapping = getDefaultMappingColumn!Owner;
    }

    // Ensure the mapping column is present on the entity.
    static assert(hasColumn!(E, mapping), "Entity `" ~ E.stringof ~ "` doesn't have column `" ~ mapping ~ "`.");
    auto mapped = __traits(getMember, entity, getColumnField!(E, mapping));

    auto relation = Model!Owner
        .select(getColumnNames!Owner)
        .where(getIDColumnName!Owner, mapped);

    __traits(getMember, entity, field) = RelationType!(E, field)(relation);
}
