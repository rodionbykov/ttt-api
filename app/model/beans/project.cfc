component persistent="true" accessors="true" table="projects" {

    property name="id" fieldtype="id" generator="native" column="id" setter="false";
    property name="name" length="100";
    property name="description";
    property name="created" ormtype="timestamp";
    property name="moment" ormtype="timestamp";
    property name="duration";
    property name="isactive";

    property name="tasks"
             fieldtype="one-to-many"
             cfc="task"
             fkcolumn="id_project"
             orderby="moment desc"
             where="isactive = 1"
             type="array"
             singularname="task"
             inverse="true";
             
    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="id_user" lazy="true";

    function toStruct(){
        var result = {};

        result.id = THIS.getID();
        result.name = THIS.getName();
        result.description = THIS.getDescription();

        if( IsNull( THIS.getCreated() ) ){
           result.created = "";
        }else{
           result.created = getIsoTimeString( THIS.getCreated() );
        }

        if( IsNull( THIS.getMoment() ) ){
            result.moment = "";
        }else{
            result.moment = getIsoTimeString( THIS.getMoment() );
        }

        result.duration = THIS.getDuration();

        if ( IsArray( THIS.getTasks() ) AND ArrayLen( THIS.getTasks() ) GT 0 ) {
            result.tasks = [];

            for(var t in THIS.getTasks()){
                ArrayAppend(result.tasks, t.toStruct());
            }
        }

        return result;
    }

    function getIsoTimeString(dt) {
        if( IsNull(dt) ){
            dt = "";
        }
        if(Len(dt) EQ 0){
            return "";
        }else{
            return (
                    dateFormat( dt, "yyyy-mm-dd" ) &
                    "T" &
                    timeFormat( dt, "HH:mm:ss" ) &
                    "Z"
                    );
        }
    }

}
