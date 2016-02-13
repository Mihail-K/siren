
module siren.model.record;

import siren.entity.base;
import siren.model.base;

template Void()
{
}

mixin template Record(M = typeof(Void!()))
{
private:
    static if(!is(M == typeof(Void!())))
    {
        static assert(is(M : Model!(typeof(this))));
        static const auto _model = new M;
    }
    else
    {
        static const auto _model = new Model!(typeof(this));
    }

    alias _model this;
}
