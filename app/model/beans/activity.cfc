component persistent="true" accessors="true" table="activities" {

    property name="id" fieldtype="id" generator="native" column="id" setter="false";
    property name="description" length="255";
    property name="created";
    property name="started";
    property name="stopped";
    property name="moment";
    property name="duration";
    property name="isrunning";
    property name="isactive";

    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="id_user" lazy="true";
    property name="task" fieldtype="many-to-one" cfc="task" fkcolumn="id_task" lazy="true";

    function toStruct(){
        var result = {};

        result.id = THIS.getID();
        result.description = THIS.getDescription();

        if( IsNull(THIS.getCreated()) ){
            result.created = "";
        }else{
            result.created = getIsoTimeString( THIS.getCreated() );
        }

        if( IsNull(THIS.getStarted()) ){
            result.started = "";
        }else{
            result.started = getIsoTimeString( THIS.getStarted() );
        }

        if( IsNull(THIS.getStopped()) ){
            result.stopped = "";
        }else{
            result.stopped = getIsoTimeString( THIS.getStopped() );
        }

        if( IsNull(THIS.getMoment()) ){
            result.moment = "";
        }else{
            result.moment = getIsoTimeString( THIS.getMoment() );
        }

        result.duration = THIS.getDuration();
        result.isrunning = THIS.getIsRunning();

        if( NOT IsNull( THIS.getTask() ) ){
            result.task = {};
            result.task.id = THIS.getTask().getID();
            result.task.title = THIS.getTask().getTitle();
            
            if( NOT IsNull( THIS.getTask().getProject() ) ){
                result.task.project = {};
                result.task.project.id = THIS.getTask().getProject().getID();
                result.task.project.name = THIS.getTask().getProject().getName();
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
