
module siren.model.exception;

import siren.entity;
import siren.exception;

import std.conv;

class EntityNotDestroyedException : SirenException
{
    this(string entity, string id)
    {
        super("Entity `" ~ entity ~ "` with ID `" ~ id ~ "` not destroyed.");
    }

    static auto create(E)(E entity)
    {
        auto id = get!(E, getIDColumnField!E)(entity);

        return new EntityNotDestroyedException(E.stringof, id.text);
    }
}

class EntityNotFoundException : SirenException
{
    this(string entity, string id)
    {
        super("Entity `" ~ entity ~ "` with ID `" ~ id ~ "` not found.");
    }

    static auto create(E)(IDType!E id)
    {
        return new EntityNotFoundException(E.stringof, id.text);
    }
}

class EntityNotUpdatedException : SirenException
{
    this(string entity, string id)
    {
        super("Entity `" ~ entity ~ "` with ID `" ~ id ~ "` not updated.");
    }

    static auto create(E)(E entity)
    {
        auto id = get!(E, getIDColumnField!E)(entity);

        return new EntityNotUpdatedException(E.stringof, id.text);
    }
}
