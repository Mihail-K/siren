
module siren.entity.associations;

mixin template Associations()
{
    import siren.association;
    import siren.entity.base;
    import siren.relation;

    import std.meta;
    import std.traits;

public:
    struct MappedBy
    {
    private:
        string _mapping;

    public:
        @disable
        this();

        this(string mapping)
        {
            _mapping = mapping;
        }

        @property
        string mapping()
        {
            return _mapping;
        }
    }

    alias associations = Filter!(hasAssociation, FieldNameTuple!(typeof(this)));

    template mappedBy(string association)
    if(hasAssociation!association)
    {
        alias member = Alias!(__traits(getMember, typeof(this), association));
        alias Type = typeof(member);

        alias Associated = AssociatedType!Type;
        alias Association = AssociationType!Type;

        static if(getUDAs!(member, MappedBy).length > 0)
        {
            enum mappedBy = getUDAs!(member, MappedBy)[$ - 1].mapping;
        }
        else static if(__traits(isSame, Association, OwnedBy))
        {
            enum mappedBy = Associated.table ~ "_" ~ Associated.primaryKeyName;
        }
        else static if(__traits(isSame, Association, HasOne) ||
                       __traits(isSame, Association, HasMany))
        {
            enum mappedBy = typeof(this).table ~ "_" ~ typeof(this).primaryKeyName;
        }
        else
        {
            static assert(0, "Unsupported association `" ~ Association.stringof ~ "`.");
        }
    }

    template hasAssociation(string member)
    {
        alias Type = typeof(__traits(getMember, typeof(this), member));
        enum hasAssociation = isAssociation!Type;
    }

    void loadEntityAssociations()
    {
        foreach(association; typeof(this).associations)
        {
            this.loadEntityAssociation!association;
        }
    }

    void loadEntityAssociation(string association)()
    if(hasAssociation!association)
    {
        alias Type = typeof(__traits(getMember, typeof(this), association));
        enum mapping = typeof(this).mappedBy!association;

        Type value = Type.create!(typeof(this), mapping)(this);
        __traits(getMember, this, association) = value;
    }
}
