
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
        template isRelation(string member)
        {
            alias Type = typeof(__traits(getMember, typeof(this), member));

            static if(__traits(compiles, TemplateOf!Type))
            {
                enum isRelation = __traits(isSame, TemplateOf!Type, HasOne) ||
                                  __traits(isSame, TemplateOf!Type, HasMany) ||
                                  __traits(isSame, TemplateOf!Type, OwnedBy);
            }
            else
            {
                enum isRelation = false;
            }
        }

        template RelationshipType(string member)
        if(isRelation!member)
        {
            alias RelationshipType = TemplateOf!(RelationType!member);
        }

        template RelationType(string member)
        if(isRelation!member)
        {
            alias RelationType = typeof(__traits(getMember, typeof(this), member));
        }

        template RelatedType(string member)
        if(isRelation!member)
        {
            alias RelatedType = TemplateArgsOf!(RelationType!member)[0];
        }

        template getRelations(E)
        {
            template _isRelation(string member)
            {
                enum _isRelation = isRelation!(member);
            }

            alias getRelations = Filter!(_isRelation, FieldNameTuple!E);
        }

        this.set(names, values);

        foreach(relation; getRelations!(typeof(this)))
        {
            alias Type = RelationType!relation;
            alias Related = RelatedType!relation;
            alias Relationship = RelationshipType!relation;

            static if(__traits(isSame, Relationship, HasOne))
            {
                enum foreign = typeof(this).tableDefinition.name ~ "_" ~
                               primaryColumn!(typeof(this).tableDefinition).name;

                static assert(
                    __traits(hasMember, Related, foreign.toCamelCase),
                    "Entity `" ~ Related.stringof ~ "` doesn't have mapping `" ~ foreign.toCamelCase ~ "`."
                );

                auto binding = new HasOneRelation!(typeof(this), Related, foreign)(this);
                __traits(getMember, this, relation) = Type(binding);
            }
            else static if(__traits(isSame, Relationship, HasMany))
            {
                enum foreign = typeof(this).tableDefinition.name ~ "_" ~
                               primaryColumn!(typeof(this).tableDefinition).name;

                static assert(
                    __traits(hasMember, Related, foreign.toCamelCase),
                    "Entity `" ~ Related.stringof ~ "` doesn't have mapping `" ~ foreign.toCamelCase ~ "`."
                );

                auto binding = new HasManyRelation!(typeof(this), Related, foreign)(this);
                __traits(getMember, this, relation) = Type(binding);
            }
            else static if(__traits(isSame, Relationship, OwnedBy))
            {
                enum foreign = Related.tableDefinition.name ~ "_" ~
                               primaryColumn!(Related.tableDefinition).name;

                static assert(
                    __traits(hasMember, typeof(this), foreign.toCamelCase),
                    "Entity `" ~ typeof(this).stringof ~ "` doesn't have mapping `" ~ foreign.toCamelCase ~ "`."
                );

                auto binding = new OwnedByRelation!(Related, typeof(this), foreign)(this);
                __traits(getMember, this, relation) = Type(binding);
            }
        }
    }

    void hydrate(Nullable!Variant[string] values)
    {
        this.hydrate(values.keys, values.values);
    }
}
