
module siren.config;

import std.algorithm;
import std.array;
import std.exception;
import std.stdio;
import std.string;

enum SirenProperty : string
{
    DefaultAdapter = "siren::default-adapter"
}

final class Config
{
private:
    static string[string] _configuration;
    static bool _initialized;

public:
    @property
    static string defaultAdapter()
    {
        return opIndex(SirenProperty.DefaultAdapter);
    }

    static void initialize(string[string] configuration)
    {
        enforce(!_initialized, "Siren already initialized.");

        _configuration = configuration;
        _initialized = true;
    }

    static void load(string[] files = [ "config.siren" ]...)
    {
        load(files.map!(file => File(file, "r")).array);
    }

    static void load(File[] files)
    {
        string[string] config;

        foreach(file; files)
        {
            foreach(line; file.byLine)
            {
                auto index = line.countUntil('=');
                if(index == -1) continue;

                string key   = line[0 .. index + 0].strip.idup;
                string value = line[index + 1 .. $].strip.idup;
                if(key.empty || value.empty) continue;

                config[key] = value;
            }
        }

        initialize(config);
    }

    static string opIndex(string property)
    {
        auto ptr = property in _configuration;
        return ptr !is null ? *ptr : null;
    }
}
