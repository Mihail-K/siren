
module siren.entity.relations;

mixin template Relations()
{
    import siren.entity.base;
    import siren.relation;

    import std.meta;
    import std.traits;

    static assert(isEntity!(typeof(this)));
    static assert(__traits(hasMember, typeof(this), "set"));

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

    @property
    static auto relation()
    {
        return new Relation!(typeof(this));
    }

    void hydrate(string[] names, Nullable!Variant[] values)
    {
        template _isRelation(string member)
        {
            alias Type = typeof(__traits(getMember, typeof(this), member));

            enum _isRelation = isRelation!Type;
        }

        this.set(names, values);

        foreach(relation; Filter!(_isRelation, FieldNameTuple!(typeof(this))))
        {
            alias Type = typeof(__traits(getMember, typeof(this), relation));

            alias Related = RelatedType!Type;
            alias Relationship = RelationType!Type;

            static if(__traits(isSame, Relationship, HasOne))
            {
                enum foreign = typeof(this).tableDefinition.name ~ "_" ~
                               primaryColumn!(typeof(this).tableDefinition).name;

                auto value = Type.create!(typeof(this), Related, foreign)(this);
                __traits(getMember, this, relation) = value;
            }
            else static if(__traits(isSame, Relationship, HasMany))
            {
                enum foreign = typeof(this).tableDefinition.name ~ "_" ~
                               primaryColumn!(typeof(this).tableDefinition).name;

                auto value = Type.create!(typeof(this), Related, foreign)(this);
                __traits(getMember, this, relation) = value;
            }
            else static if(__traits(isSame, Relationship, OwnedBy))
            {
                enum foreign = Related.tableDefinition.name ~ "_" ~
                               primaryColumn!(Related.tableDefinition).name;

                auto value = Type.create!(Related, typeof(this), foreign)(this);
                __traits(getMember, this, relation) = value;
            }
        }
    }

    void hydrate(Nullable!Variant[string] values)
    {
        this.hydrate(values.keys, values.values);
    }
}
