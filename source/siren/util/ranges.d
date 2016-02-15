
module siren.util.ranges;

import std.range;
import std.traits;

@property
ElementType!Range first(Range)(Range range)
if(isInputRange!(Unqual!Range) && !isRandomAccessRange!(Unqual!Range))
{
    return range.takeOne.front;
}

@property
ElementType!Range first(Range)(Range range)
if(isRandomAccessRange!(Unqual!Range))
{
    return range[0];
}

@property
ElementType!Range second(Range)(Range range)
if(isInputRange!(Unqual!Range) && !isRandomAccessRange!(Unqual!Range))
{
    return range.dropOne.first;
}

@property
ElementType!Range second(Range)(Range range)
if(isRandomAccessRange!(Unqual!Range))
{
    return range[1];
}

@property
ElementType!Range third(Range)(Range range)
if(isInputRange!(Unqual!Range) && !isRandomAccessRange!(Unqual!Range))
{
    return range.dropExactly(2).first;
}

@property
ElementType!Range third(Range)(Range range)
if(isRandomAccessRange!(Unqual!Range))
{
    return range[2];
}

@property
ElementType!Range fourth(Range)(Range range)
if(isInputRange!(Unqual!Range) && !isRandomAccessRange!(Unqual!Range))
{
    return range.dropExactly(3).first;
}

@property
ElementType!Range fourth(Range)(Range range)
if(isRandomAccessRange!(Unqual!Range))
{
    return range[3];
}

@property
ElementType!Range fifth(Range)(Range range)
if(isInputRange!(Unqual!Range))
{
    return range.dropExactly(4).first;
}

@property
ElementType!Range fifth(Range)(Range range)
if(isRandomAccessRange!(Unqual!Range))
{
    return range[4];
}

@property
ElementType!Range last(Range)(Range range)
if(!isInfinite!(Unqual!Range) && hasLength!(Unqual!Range) && !isRandomAccessRange!(Unqual!Range))
{
    return range.dropExactly(range.length - 1).first;
}

@property
ElementType!Range last(Range)(Range range)
if(isBidirectionalRange!(Unqual!Range) && !isRandomAccessRange!(Unqual!Range))
{
    return range.retro.first;
}

@property
ElementType!Range last(Range)(Range range)
if(isRandomAccessRange!(Unqual!Range))
{
    return range[range.length - 1];
}
