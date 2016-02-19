
module siren.entity.attributes;

import siren.schema;
import siren.util;

import std.array;
import std.string;

mixin template Attributes()
{
    import siren.entity;

    static assert(isEntity!(typeof(this)));

private:
    /++
     + Dynamically introduces fields corresponding to fields present in the
     + Entity's table definition.
     ++/
    mixin(fields(typeof(this).tableDefinition));

public:
    /++
     + Dynamically introduces read and write properties to fields present in
     + the Entity's table definition.
     ++/
    mixin(properties(typeof(this).tableDefinition));
}

/+ - Code Generation - +/

string fields(TableDefinition table)
{
    auto buffer = appender!string;

    foreach(column; table.columns)
    {
        buffer ~= "%2$s _%1$s;\n".format(
            column.name.toCamelCase,
            column.dtype
        );
    }

    return buffer.data;
}

string properties(TableDefinition table)
{
    auto buffer = appender!string;

    foreach(column; table.columns)
    {
        buffer ~= "
        @property %2$s %1$s() { return this._%1$s; }
        @property %2$s %1$s(%2$s value) { return this._%1$s = value; }
        ".format(
            column.name.toCamelCase,
            column.dtype
        );
    }

    return buffer.data;
}
