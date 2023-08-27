component persistent="true" accessors="true" table="roles"{

    property name="id" fieldtype="id" generator="native" column="id" setter="false";
    property name="pluralname";
    property name="singularname";
    property name="isdefault";
    property name="isactive";

    property name="tokens"
            fieldtype="one-to-many"
            cfc="token"
            fkcolumn="id_role"
            orderby="token"
            type="array"
            singularname="token"
            inverse="true";

}