
module siren.relation.finders;

mixin template Finders(Subject)
{
    import siren.entity;
    import siren.schema;
    import siren.util;

    static assert(isEntity!Subject);

    // Ensure the outer type defines a project function.
    static assert(__traits(hasMember, typeof(this), "project"));

    // Ensure the outer type defines a where function.
    static assert(__traits(hasMember, typeof(this), "where"));

public:
    static if(hasPrimary!(Subject.tableDefinition))
    {
        Subject find(PrimaryType!(Subject.tableDefinition) id)
        {
            scope(success)
            {
                this.popFront;
            }

            return this
                .project(tableColumnNames!(Subject.tableDefinition))
                .where(primaryColumn!(Subject.tableDefinition).name, id)
                .limit(1)
                .front;
        }

        Subject find(Subject entity)
        {
            enum primary = primaryColumn!(Subject.tableDefinition).name;
            auto id = __traits(getMember, entity, primary.toCamelCase);

            return find(id);
        }

        static if(isNullableWrapped!(PrimaryType!(Subject.tableDefinition)))
        {
            Subject find(UnwrapNullable!(PrimaryType!(Subject.tableDefinition)) id)
            {
                PrimaryType!(Subject.tableDefinition) nullable = id;

                return find(nullable);
            }
        }

        Relation!Subject findList(PrimaryType!(Subject.tableDefinition)[] ids...)
        {
            return null; // TODO : WHERE-IN
        }
    }

    Relation!Subject findBy(TList...)(TList args)
    {
        return where(args).limit(1);
    }
}
