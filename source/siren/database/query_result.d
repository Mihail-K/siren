
module siren.database.query_result;

import siren.database.query_row;

interface QueryResult
{
    @property
    string[] columns();

    @property
    bool empty();

    @property
    QueryRow front();

    void popFront();

    void reset();
}
