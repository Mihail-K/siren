
module siren.database.adapter_provider;

import siren.config;
import siren.database.adapter;

import std.exception;
import std.traits;

final class AdapterProvider
{
    /++
     + A marker token issued to unregister an adapter once registered.
     ++/
    static final class Token
    {
        private shared this()
        {
            // Hidden constructor.
        }

        override bool opEquals(Object o)
        {
            return o is this;
        }

        override string toString()
        {
            return "Token";
        }
    }

private:
    static Adapter[string] _cachedAdapters;
    static ClassInfo[string] _registeredAdapters;
    static string[shared(Token)] _tokens;

public:
    /++
     + Retrieves an adapter with the given name, if one is registered.
     + The adapter is constructed when first accessed, and is cached thereafter.
     ++/
    static T get(T : Adapter = Adapter)(string name = Config.defaultAdapter)
    {
        enforce(name !is null, "Cannot get adapter with null name.");
        auto cachePtr = name in _cachedAdapters;

        if(cachePtr !is null)
        {
            return cast(T) *cachePtr;
        }
        else
        {
            auto classPtr = name in _registeredAdapters;
            enforce(classPtr !is null, "No registered Adapter `" ~ name ~ "`.");

            auto adapter = cast(T) classPtr.create;
            _cachedAdapters[name] = adapter;

            return adapter;
        }
    }

    /**
     * Checks if a database adapter is cached with the given name.
     **/
    static bool isCached(string name)
    {
        return !!(name in _cachedAdapters);
    }

    /++
     + Checks if a database adapter is registered with the given name.
     ++/
    static bool isRegistered(string name)
    {
        return !!(name in _registeredAdapters);
    }

    /++
     + Registers an adapter to the given name using a template type.
     + A token is issued, which can be used to unregister the adapter.
     ++/
    static shared(Token) register(A : Adapter)(string name)
    {
        enum typename = fullyQualifiedName!A;
        return register(name, cast(ClassInfo) ClassInfo.find(typename));
    }

    private static shared(Token) register()(string name, ClassInfo class_)
    {
        enforce(class_, "Cannot register adapter with null class.");
        enforce(name !in _registeredAdapters, "Adapter `" ~ name ~ "` already registered.");

        auto token = new shared Token;
        _registeredAdapters[name] = class_;
        _tokens[token] = name;

        return token;
    }

    /++
     + Unregisters an adapter, using a previously issued token.
     ++/
    static void unregister(shared(Token) token)
    {
        auto namePtr = token in _tokens;
        enforce(namePtr !is null, "No Adapter registered to Token.");

        string name = *namePtr;
        _registeredAdapters.remove(name);

        auto cachePtr = name in _cachedAdapters;

        // Finalize the adapter.
        if(cachePtr !is null)
        {
            cachePtr.close;
            _cachedAdapters.remove(name);
        }
    }
}
