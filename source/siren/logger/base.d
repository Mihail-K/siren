
module siren.logger.base;

import siren.logger.colour;

import consoled;

import std.stdio;
import std.traits;

private struct Level(int l)
{
    @property
    enum level = l;
}

struct Log
{
    enum Trace    = Level!(0).init;
    enum Info     = Level!(1).init;
    enum Warn     = Level!(2).init;
    enum Warning  = Level!(2).init;
    enum Error    = Level!(3).init;
    enum Crit     = Level!(4).init;
    enum Critical = Level!(4).init;

    static string toString(int l)(Level!(l) level)
    {
        static if(l == Trace.level)
        {
            return "[DBUG]";
        }
        else static if(l == Info.level)
        {
            return "[INFO]";
        }
        else static if(l == Warning.level)
        {
            return "[WARN]";
        }
        else static if(l == Error.level)
        {
            return "[ERR!]";
        }
        else static if(l == Critical.level)
        {
            return "[CRIT]";
        }
        else
        {
            static assert(0);
        }
    }

    static Coloured toColouredString(int l)(Level!(l) level)
    {
        static if(l == Trace.level)
        {
            return Log.toString(level).uncolour;
        }
        else static if(l == Info.level)
        {
            return Log.toString(level).cyan;
        }
        else static if(l == Warning.level)
        {
            return Log.toString(level).yellow;
        }
        else static if(l == Error.level)
        {
            return Log.toString(level).magenta;
        }
        else static if(l == Critical.level)
        {
            return Log.toString(level).red.light;
        }
        else
        {
            static assert(0);
        }
    }
}

class Logger
{
    private static void put(T)(T argument)
    {
        static if(is(typeof(argument) == Coloured))
        {
            // Reset colour after write.
            scope(exit) foreground = Colour.initial;

            foreground = argument.colour;
            write(argument.text);
        }
        else
        {
            write(argument);
        }
    }

    static void log(int l, TList...)(Level!(l) level, TList args)
    {
        // Filterable log levels.
        static if(isLogLevelActive!(l))
        {
            // Write coloured log-level prefix.
            Logger.put(Log.toColouredString(level));
            Logger.put(" ");

            foreach(argument; args)
            {
                Logger.put(argument);
            }

            writeln;
        }
    }

    static void trace(TList...)(TList args)
    {
        Logger.log(Log.Trace, args);
    }

    static void info(TList...)(TList args)
    {
        Logger.log(Log.Info, args);
    }

    alias warn = warning;

    static void warning(TList...)(TList args)
    {
        Logger.log(Log.Warning, args);
    }

    static void error(TList...)(TList args)
    {
        Logger.log(Log.Error, args);
    }

    alias crit = critical;

    static void critical(TList...)(TList args)
    {
        Logger.log(Log.Critical, args);
    }
}

mixin template dump(string expr)
{
    // Check that trace level logs are enabled.
    static if(isLogLevelActive!(Log.Trace.level))
    {
        private int _dump()
        {
            mixin("auto result = " ~ expr ~";");
            Logger.trace(expr, " = ", result);

            return 1;
        }

        private int __dump = _dump;
    }
}

template isLogLevelActive(int l)
{
    enum isLogLevelActive = true; // TODO
}
