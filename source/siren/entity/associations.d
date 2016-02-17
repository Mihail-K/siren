
module siren.entity.associations;

mixin template Associations()
{
    import siren.association;
    import siren.entity.base;
    import siren.relation;

    import std.meta;
    import std.traits;

    static assert(isEntity!(typeof(this)));

public:
    static if(hasPrimary!(typeof(this).tableDefinition))
    {
        static typeof(this) find(PrimaryType!(typeof(this).tableDefinition) id)
        {
            return typeof(this).relation.find(id);
        }

        static typeof(this) find(typeof(this) entity)
        {
            return typeof(this).relation.find(entity);
        }

        static if(isNullableWrapped!(PrimaryType!(typeof(this).tableDefinition)))
        {
            static typeof(this) find(UnwrapNullable!(PrimaryType!(typeof(this).tableDefinition)) id)
            {
                PrimaryType!(typeof(this).tableDefinition) nullable = id;

                return typeof(this).find(nullable);
            }
        }
    }

    static Relation!(typeof(this)) relation()
    {
        return new Relation!(typeof(this));
    }

    protected enum _isAssociation(string member) = isAssociation!(
        typeof(__traits(getMember, typeof(this), member))
    );

    alias associations = Filter!(
        _isAssociation, FieldNameTuple!(typeof(this))
    );

    void prepareAssociations()
    {
        foreach(association; typeof(this).associations)
        {
            this.prepareAssociation!association;
        }
    }

    void prepareAssociation(string association)()
    {
        static assert(_isAssociation!association);

        alias Type = typeof(__traits(getMember, typeof(this), association));

        alias Associated = AssociatedType!Type;
        alias Association = AssociationType!Type;

        static if(__traits(isSame, Association, HasOne))
        {
            enum foreign = typeof(this).tableDefinition.name ~ "_" ~
                           primaryColumn!(typeof(this).tableDefinition).name;

            auto value = Type.create!(typeof(this), Associated, foreign)(this);
            __traits(getMember, this, association) = value;
        }
        else static if(__traits(isSame, Association, HasMany))
        {
            enum foreign = typeof(this).tableDefinition.name ~ "_" ~
                           primaryColumn!(typeof(this).tableDefinition).name;

            auto value = Type.create!(typeof(this), Associated, foreign)(this);
            __traits(getMember, this, association) = value;
        }
        else static if(__traits(isSame, Association, OwnedBy))
        {
            enum foreign = Associated.tableDefinition.name ~ "_" ~
                           primaryColumn!(Associated.tableDefinition).name;

            auto value = Type.create!(Associated, typeof(this), foreign)(this);
            __traits(getMember, this, association) = value;
        }
    }
}
