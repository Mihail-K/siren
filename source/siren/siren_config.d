
module siren.siren_config;

import std.exception;

enum SirenProperty : string
{
    DefaultAdapter = "siren::default-adapter"
}

final class SirenConfig
{
public:

private:
    static bool _initialized;
    static string[string] _configuration;

public:
    static void initialize(string[string] configuration)
    {
        enforce(!_initialized, "Siren already initialized.");

        _configuration = configuration;
        _initialized = true;
    }

    @property
    static string defaultAdapter()
    {
        return opIndex(SirenProperty.DefaultAdapter);
    }

    static string opIndex(string property)
    {
        auto ptr = property in _configuration;
        return ptr !is null ? *ptr : null;
    }
}
