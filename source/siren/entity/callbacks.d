
module siren.entity.callbacks;

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

alias Do = Callback;

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

mixin template Callbacks()
{
    import std.meta;
    import std.traits;

    void raise(CallbackEvent event)
    {
        template isCallback(string name)
        {
            static if(is(typeof(__traits(getMember, typeof(this), name)) == function))
            {
                enum isCallback = getUDAs!(__traits(getMember, typeof(this), name), Callback).length > 0;
            }
            else
            {
                enum isCallback = false;
            }
        }

        template getCallbackAttributes(string name)
        {
            alias member = Alias!(__traits(getMember, typeof(this), name));

            alias getCallbackAttributes = getUDAs!(member, Callback);
        }

        enum members = __traits(allMembers, typeof(this));
        OUTER: foreach(member; Filter!(isCallback, members))
        {
            foreach(attribute; getCallbackAttributes!member)
            {
                if(attribute.handles(event))
                {
                    __traits(getMember, typeof(this), member)();
                    continue OUTER;
                }
            }
        }
    }
}
