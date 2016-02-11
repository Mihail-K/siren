
module siren.exception;

class SirenException : Exception
{
@safe @nogc pure nothrow:
    this(string message = "Siren Exception", Throwable t = null)
    {
        super(message, t);
    }

    this(string message, string file, uint line, Throwable t = null)
    {
        super(message, file, line, t);
    }
}

class SirenError : Error
{
@safe @nogc pure nothrow:
    this(string message = "Siren Error", Throwable t = null)
    {
        super(message, t);
    }
}
