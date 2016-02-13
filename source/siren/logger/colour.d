
module siren.logger.colour;

import consoled;

import std.conv;
import std.stdio;

struct Coloured
{
private:
    Colour _colour;
    string _text;

public:
    @disable
    this();

    this(Colour colour, string text)
    {
        _colour = colour;
        _text   = text;
    }

    @property
    Colour colour() const
    {
        return _colour;
    }

    @property
    string text() const
    {
        return _text;
    }

    string toString() const
    {
        return _text;
    }
}

alias Colour = Color;

@property
Colour blue()
{
    return Colour.blue;
}

@property
Coloured blue(T)(T output)
{
    return Coloured(Colour.blue, output.text);
}

@property
Coloured green(T)(T output)
{
    return Coloured(Colour.green, output.text);
}

@property
Coloured cyan(T)(T output)
{
    return Coloured(Colour.cyan, output.text);
}

@property
Coloured red(T)(T output)
{
    return Coloured(Colour.red, output.text);
}

@property
Coloured magenta(T)(T output)
{
    return Coloured(Colour.magenta, output.text);
}

@property
Coloured yellow(T)(T output)
{
    return Coloured(Colour.yellow, output.text);
}

@property
Coloured grey(T)(T output)
{
    return Coloured(Colour.gray, output.text);
}

@property
Coloured white(T)(T output)
{
    return Coloured(Colour.white, output.text);
}

@property
Coloured silver(T)(T output)
{
    return Coloured(Colour.lightGray, output.text);
}

@property
Coloured light(Coloured output)
{
    return Coloured(cast(Colour)(output.colour | Colour.bright), output.text);
}

@property
Coloured dark(Coloured output)
{
    return Coloured(cast(Colour)(output.colour & ~Colour.bright), output.text);
}

@property
Coloured uncolour(T)(T output)
{
    return Coloured(cast(Colour) Colour.initial, output.text);
}
