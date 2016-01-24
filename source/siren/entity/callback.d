
module siren.entity.callback;

import siren.entity.attributes;
import siren.entity.base;

import std.algorithm;
import std.array;
import std.exception;
import std.meta;
import std.traits;

enum CallbackEvent : string
{
    /++
     + Fired after an entity-create event.
     ++/
    AfterCreate  = "after-create",
    /++
     + Fired before an entity-create event.
     ++/
    BeforeCreate = "before-create",

    /++
     + Fired after a transaction-commit event.
     ++/
    AfterCommit  = "after-commit",

    /++
     + Fired after an entity-destroy event.
     ++/
    AfterDestroy  = "after-destroy",
    /++
     + Fired before an entity-destroy event.
     ++/
    BeforeDestroy = "before-destroy",

    /++
     + Fired after entity construction.
     ++/
    AfterLoad = "after-load",

    /++
     + Fired after a transaction-rollback event.
     ++/
    AfterRollback = "after-rollback",

    /++
     + Fired after an entity-save event.
     ++/
    AfterSave  = "after-save",
    /++
     + Fired before an entity-save event.
     ++/
    BeforeSave = "before-save",

    /++
     + Fired after entity validation.
     ++/
    AfterValidation  = "after-validation",
    /++
     + Fired before entity validation.
     ++/
    BeforeValidation = "before-validation",

    /++
     + Fired after an entity-update event.
     ++/
    AfterUpdate  = "after-update",
    /++
     + Fired before an entity-update event.
     ++/
    BeforeUpdate = "before-update"
}

@property
CallbackEvent toCallbackEvent(string str)
{
    foreach(event; EnumMembers!CallbackEvent)
    {
        if(str == cast(string) event)
        {
            return event;
        }
    }

    assert(0, "No event type `" ~ str ~ "`.");
}

struct Callback
{
private:
    CallbackEvent[] _events;

public:
    this(string[] events...)
    {
        this(events.map!toCallbackEvent.array);
    }

    this(CallbackEvent[] events...)
    {
        _events = events;
    }

    @property
    CallbackEvent[] events()
    {
        return _events;
    }

    bool handles(CallbackEvent event)
    {
        return _events.countUntil(event) != -1;
    }
}

/+ - Run-Time Helpers - +/

void fire(CallbackEvent event, E : Entity)(E entity)
{
    foreach(member; getCallbackFunctionsForEvent!(E, event))
    {
        static if(arity!(__traits(getMember, E, member)) == 0)
        {
            __traits(getMember, entity, member)();
        }
        else
        {
            __traits(getMember, entity, member)(entity);
        }
    }
}

/+ - Compile-Time Helpers - +/

template isCallback(E : Entity, string member)
{
    static if(isAccessibleFunction!(E, member))
    {
        enum isCallback = getUDAs!(__traits(getMember, E, member), Callback).length > 0;
    }
    else
    {
        enum isCallback = false;
    }
}

template isCallbackForEvent(E : Entity, string member, CallbackEvent event)
{
    template _isCallbackForEvent(Callback callback)
    {
        enum _isCallbackForEvent = callback.handles(event);
    }

    enum isCallbackForEvent = Filter!(_isCallbackForEvent, getCallbacks!(E, member)).length > 0;
}

template getCallbacks(E : Entity, string member)
{
    static if(isCallback!(E, member))
    {
        alias getCallbacks = getUDAs!(__traits(getMember, E, member), Callback);
    }
    else
    {
        alias getCallbacks = AliasSeq!();
    }
}

template getCallbackFunctions(E : Entity)
{
    template _isCallback(string member)
    {
        enum _isCallback = isCallback!(E, member);
    }

    alias getCallbackFunctions = Filter!(_isCallback, __traits(allMembers, E));
}

template getCallbackFunctionsForEvent(E : Entity, CallbackEvent event)
{
    template _isCallbackForEvent(string member)
    {
        enum _isCallbackForEvent = isCallbackForEvent!(E, member, event);
    }

    alias functions = getCallbackFunctions!E;

    alias getCallbackFunctionsForEvent = Filter!(_isCallbackForEvent, functions);
}
