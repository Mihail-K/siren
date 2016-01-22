
module siren.util.escaped_string;

struct EscapedString
{
private:
    string _value;

public:
    this(string value)
    {
        _value = value;
    }

    @property
    string value()
    {
        return _value;
    }
}

@property
EscapedString assumeEscaped(string value)
{
    return EscapedString(value);
}

@property
EscapedString assumeEscaped(EscapedString value)
{
    return value;
}
