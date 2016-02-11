
module siren.logger.colour;

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

@property
Coloured blue(T)(T output)
{
    return Coloured(Colour.Blue, output.text);
}

@property
Coloured green(T)(T output)
{
    return Coloured(Colour.Green, output.text);
}

@property
Coloured cyan(T)(T output)
{
    return Coloured(Colour.Cyan, output.text);
}

@property
Coloured red(T)(T output)
{
    return Coloured(Colour.Red, output.text);
}

@property
Coloured magenta(T)(T output)
{
    return Coloured(Colour.Magenta, output.text);
}

@property
Coloured yellow(T)(T output)
{
    return Coloured(Colour.Yellow, output.text);
}

@property
Coloured grey(T)(T output)
{
    return Coloured(Colour.Grey, output.text);
}

@property
Coloured white(T)(T output)
{
    return Coloured(Colour.White, output.text);
}

@property
Coloured light(Coloured output)
{
    return Coloured(cast(Colour)(output.colour | Colour.Light), output.text);
}

@property
Coloured dark(Coloured output)
{
    return Coloured(cast(Colour)(output.colour & ~Colour.Light), output.text);
}

@property
Coloured uncolour(Coloured output)
{
    return Coloured(cast(Colour) _neutralForeground, output.text);
}

private shared
{
    ushort _background;
    ushort _foreground;

    ushort _neutralForeground;
    ushort _neutralBackground;
}

@property
void resetColour()
{
    _foreground = _neutralForeground;
    _background = _neutralBackground;

    colourize;
}

version(Windows)
{
    import std.c.windows.windows;

    enum Colour : ushort
    {
        Black   = 0x00,

        Blue    = 0x01,
        Green   = 0x02,
        Cyan    = 0x03,
        Red     = 0x04,
        Magenta = 0x05,
        Yellow  = 0x06,
        Silver  = 0x07,

        Grey    = 0x08,
        White   = 0x0F,

        Light   = 0x08
    }

    shared static this()
    {
        CONSOLE_SCREEN_BUFFER_INFO info;

        if(handle.GetConsoleScreenBufferInfo(&info))
        {
            _neutralForeground = _foreground = info.foreground;
            _neutralBackground = _background = info.background;
        }
        else
        {
            _neutralForeground = _foreground = Colour.Silver;
            _neutralBackground = _background = Colour.Black;
        }
    }

    @property
    protected ushort background(ref CONSOLE_SCREEN_BUFFER_INFO info)
    {
        return cast(ushort)((info.wAttributes & 0xF0) >> 4);
    }

    @property
    protected ushort foreground(ref CONSOLE_SCREEN_BUFFER_INFO info)
    {
        return cast(ushort)((info.wAttributes & 0x0F) >> 0);
    }

    @property
    Colour background()
    {
        return cast(Colour) _background;
    }

    @property
    void background(Colour colour)
    {
        _background = cast(ushort) colour;
        colourize;
    }

    @property
    protected ushort combined()
    {
        return cast(ushort)((_background << 4) & 0xF0) | (_foreground & 0x0F);
    }

    protected void colourize()
    {
        stdout.flush;
        handle.SetConsoleTextAttribute(combined);
    }

    @property
    Colour foreground()
    {
        return cast(Colour) _foreground;
    }

    @property
    void foreground(Colour colour)
    {
        _foreground = cast(ushort) colour;
        colourize;
    }

    @property
    protected HANDLE handle()
    {
        return STD_OUTPUT_HANDLE.GetStdHandle;
    }
}

version(Posix)
{
    import core.sys.posix.fcntl;
    import core.sys.posix.termios;
    import core.sys.posix.unistd;
    import core.sys.posix.sys.ioctl;

    enum Colour : ushort
    {
        Black     = 0x1E,

        Red       = 0x1F,
        Green     = 0x20,
        Yellow    = 0x21,
        Blue      = 0x22,
        Magenta   = 0x23,
        Cyan      = 0x24,
        Silver    = 0x25,

        Grey      = 0x5E,
        White     = 0x65,

        Light     = 0x40,
        Default   = 0x100
    }

    shared static this()
    {
        _neutralForeground = Colour.Default;
        _neutralBackground = Colour.Default;
    }

    @property
    Colour background()
    {
        return cast(Colour) _background;
    }

    @property
    void background(Colour colour)
    {
        if(!isATTY)
        {
            _background = cast(ushort) colour;
            colourize;
        }
    }

    void colourize()
    {
        auto light = (_foreground &  Colour.Light) ? 1 : 0;
        auto fore  = (_foreground & ~Colour.Light) + 0;
        auto back  = (_background & ~Colour.Light) + 10;

        stdout.writef("\033[%d;%d;%d;%d;%dm", light, fore, back, 24, 29);
    }

    @property
    Colour foreground()
    {
        return cast(Colour) _foreground;
    }

    @property
    void foreground(Colour colour)
    {
        if(!isATTY)
        {
            _foreground = cast(ushort) colour;
            colourize;
        }
    }

    @property
    bool isATTY()
    {
        return stdout.getFP.fileno.isatty != 1;
    }
}
