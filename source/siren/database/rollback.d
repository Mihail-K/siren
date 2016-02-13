
module siren.database.rollback;

import siren.exception;

class Rollback : SirenException
{
private:
    bool _propogate;

public:
    this(bool propogate = false, Throwable t = null)
    {
        super(null, t);

        _propogate = propogate;
    }

    @property
    static void now(bool propogate = false, Throwable t = null)
    {
        throw new Rollback(propogate, t);
    }

    @property
    bool propogate()
    {
        return _propogate;
    }

    override string toString()
    {
        return "Siren::Rollback";
    }
}
