component persistent="true" accessors="true" table="tasks"{

    property name="id" fieldtype="id" generator="native" column="id" setter="false";
    property name="title" length="100";
    property name="description";
    property name="created";
    property name="moment";
    property name="duration";
    property name="isrunning";
    property name="isactive";

    property name="activities"
             fieldtype="one-to-many"
             cfc="activity"
             fkcolumn="id_task"
             orderby="moment desc"
             where="isactive = 1"
             type="array"
             singularname="activity"
             inverse="true";

    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="id_user" lazy="true";
    property name="project" fieldtype="many-to-one" cfc="project" fkcolumn="id_project" lazy="true";
    
    function toStruct(){
        var result = {};

        result.id = THIS.getID();
        result.title = THIS.getTitle();
        result.description = THIS.getDescription();

        if( IsNull( THIS.getCreated() ) ){
           result.created = "";
        }else{
           result.created = getIsoTimeString( THIS.getCreated() );
        }

        if( IsNull(THIS.getMoment()) ){
            result.moment = "";
        }else{
            result.moment = getIsoTimeString( THIS.getMoment() );
        }

        result.duration = THIS.getDuration();
        result.isrunning = THIS.getIsRunning();

        if ( IsArray( THIS.getActivities() ) AND ArrayLen( THIS.getActivities() ) GT 0 ) {
            result.activities = [];

            for(var a in THIS.getActivities()){
                ArrayAppend(result.activities, a.toStruct());
            }
        }

        if( NOT IsNull( THIS.getProject() ) ){
            result.project = {};
            result.project.id = THIS.getProject().getID();
            result.project.name = THIS.getProject().getName();
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
