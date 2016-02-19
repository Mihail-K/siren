
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
    static if(Subject.hasPrimary)
    {
        Subject find(Subject.PrimaryKey id)
        {
            scope(success)
            {
                this.popFront;
            }

            return this
                .project(Subject.columnNames)
                .where(Subject.primaryKeyName, id)
                .limit(1)
                .front;
        }

        Subject find(Subject entity)
        {
            return find(entity.id);
        }

        static if(isNullableWrapped!(Subject.PrimaryKey))
        {
            Subject find(UnwrapNullable!(Subject.PrimaryKey) id)
            {
                Subject.PrimaryKey nullable = id;

                return find(nullable);
            }
        }

        Relation!Subject findList(Subject.PrimaryKey[] ids...)
        {
            return null; // TODO : WHERE-IN
        }
    }

    Relation!Subject findBy(TList...)(TList args)
    {
        return where(args).limit(1);
    }
}
