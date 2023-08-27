component persistent="true" accessors="true" table="subscribers"{

    // persistent properties

    property name ="id" fieldtype="id" generator="native" column="id";
    property name ="name" length="255";
    property name ="accesskey";
    property name ="secret";
    property name ="alloworigin";
    property name ="credits";
    property name ="isactive";

    property name="users"
            fieldtype="one-to-many"
            cfc="user"
            fkcolumn="id_subscriber"
            orderby="login"
            where="isactive = 1"
            type="array"
            singularname="user"
            inverse="true";

}