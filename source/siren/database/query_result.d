
module siren.database.query_result;

import siren.database.query_row;

abstract class QueryResult
{
    @property
    string[] columns();

    @property
    bool empty();

    @property
    QueryRow front();

    void popFront();

    @property
    QueryResult save();

    void reset();
}
