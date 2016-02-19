
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
        Subject find(Subject.PrimaryColumnType id)
        {
            scope(success)
            {
                this.popFront;
            }

            return this
                .project(Subject.columnNames)
                .where(Subject.primaryColumnName, id)
                .limit(1)
                .front;
        }

        Subject find(Subject entity)
        {
            auto id = __traits(getMember, entity, Subject.primaryColumnField);

            return find(id);
        }

        static if(isNullableWrapped!(Subject.PrimaryColumnType))
        {
            Subject find(UnwrapNullable!(Subject.PrimaryColumnType) id)
            {
                Subject.PrimaryColumnType nullable = id;

                return find(nullable);
            }
        }

        Relation!Subject findList(Subject.PrimaryColumnType[] ids...)
        {
            return null; // TODO : WHERE-IN
        }
    }

    Relation!Subject findBy(TList...)(TList args)
    {
        return where(args).limit(1);
    }
}
