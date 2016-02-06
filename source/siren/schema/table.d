
module siren.schema.table;

import siren.schema.base;
import siren.schema.column;

import std.exception;

final shared class SchemaTable
{
private:
    SchemaColumn[string] _columns;

    string _name;
    Schema _schema;

package:
    shared this(string name, shared Schema schema)
    {
        _name = name;
        _schema = schema;
    }

public:
    @property
    shared(SchemaColumn) column(string name)
    {
        enforce(name !in _columns, "Duplicate column `" ~ name ~ "` for table `" ~ _name ~ "`.");

        return _columns[name] = new shared SchemaColumn(name, this);
    }

    @property
    string name()
    {
        return _name;
    }

    @property
    shared(Schema) end()
    {
        return _schema;
    }
}
