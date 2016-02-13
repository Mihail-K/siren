
module siren.logger.base;

import siren.logger.colour;

import consoled;

import std.stdio;

class Logger
{
    static void log(TList...)(TList args)
    {
        foreach(argument; args)
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

        writeln;
    }
}
