
module siren.util.names;

import std.algorithm;
import std.conv;
import std.regex;
import std.string;

/++
 + Converts a CamelCase string to lower_snake_case.
 ++/
@property
string toSnakeCase(string camelCase)
{
    static auto r1 = ctRegex!"(.)([A-Z][a-z]+)";
    static auto r2 = ctRegex!"(.)([0-9]+)";
    static auto r3 = ctRegex!"([a-z0-9])([A-Z])";

    return camelCase
        .replaceAll(r1, "$1_$2")
        .replaceAll(r2, "$1_$2")
        .replaceAll(r3, "$1_$2")
        .toLower;
}

/++
 + Converts a lower_snake_case string to camelCase.
 ++/
@property
string toCamelCase(string snakeCase, bool upper = false)
{
    auto result = snakeCase
        .split('_')
        .filter!"a.length"
        .map!toFirstUpper
        .joiner
        .text;

    return upper ? result : result.toFirstLower;
}

@property
string toFirstUpper(string input)
{
    return input.length ? input[0 .. 1].toUpper ~ input[1 .. $] : input;
}

@property
string toFirstLower(string input)
{
    return input.length ? input[0 .. 1].toLower ~ input[1 .. $] : input;
}
