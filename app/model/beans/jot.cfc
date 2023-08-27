component persistent="true" accessors="true" table="jots" {

    property name="id" fieldtype="id" generator="native" column="id" setter="false";
    property name="body";
    property name="created";
    property name="moment";
    property name="isactive";

    property name="user" fieldtype="many-to-one" cfc="user" fkcolumn="id_user" lazy="false";
    property name="project" fieldtype="many-to-one" cfc="project" fkcolumn="id_project" lazy="false";
    property name="task" fieldtype="many-to-one" cfc="task" fkcolumn="id_task" lazy="false";
    property name="activity" fieldtype="many-to-one" cfc="activity" fkcolumn="id_activity" lazy="false";

    function toStruct(){
        var result = {};

        result.id = THIS.getID();
        result.body = THIS.getBody();

        if( IsNull(THIS.getCreated()) ){
            result.created = "";
        }else{
            result.created = getIsoTimeString( THIS.getCreated() );
        }

        if( IsNull(THIS.getMoment()) ){
            result.moment = "";
        }else{
            result.moment = getIsoTimeString( THIS.getMoment() );
        }

		if( NOT IsNull( THIS.getActivity() ) ){
            result.activity = {};
            result.activity.id = THIS.getActivity().getID();
            result.activity.description = THIS.getActivity().getDescription();


        }

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
