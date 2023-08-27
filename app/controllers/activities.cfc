component {
    pageEncoding "utf-8";

    function init(fw){
        VARIABLES.fw = fw;

        VARIABLES.jsonSerializer = new lib.JsonSerializer()
                                        .asInteger('id')
                                        .asString('name')
                                        .asString('title')
                                        .asString('description')
                                        .asInteger('duration')
                                        .asBoolean('isrunning')
                                        .asDate("created")
                                        .asDate("started")
                                        .asDate("stopped")
                                        .asDate("moment");
    }

    function before(rc) {
        if (NOT rc.user.hasToken('UserLoggedIn')){
            if (IsDefined("rc.result")){
                if (IsInstanceOf(rc.result, "model.beans.error")){
                    getPageContext().getResponse().setHeader( "Access-Control-Allow-Origin", "*" );
                    VARIABLES.fw.renderData("json", rc.result.getMessage(), rc.result.getCode());
                }else{
                    VARIABLES.fw.renderData("json", "E_UNKNOWN_RESULT", 400);
                }
            }else{
                VARIABLES.fw.renderData("json", "E_ACCESS_DENIED", 400);
            }
            VARIABLES.fw.abortController();
        }
    }

    function after(rc) {
        if (IsDefined("rc.result")){
            if (IsDefined("rc.result") AND IsInstanceOf(rc.result, "model.beans.error")){
                getPageContext().getResponse().setHeader( "Access-Control-Allow-Origin", "*" );
                return VARIABLES.fw.renderData("json", rc.result.getMessage(), rc.result.getCode());
            }else{
                return VARIABLES.fw.renderData("json", VARIABLES.jsonSerializer.serialize(rc.result), 200);
            }
        }
    }

    function list(rc){
        rc.result = [];
        var activities = rc.user.getActivities();

        for (var a in activities){
            ArrayAppend(rc.result, a.toStruct());
        }
    }

    function get(rc){
        rc.result = {};
        var activities = rc.user.getActivities();

        param name="rc.id" default="0";

        for (var activity in activities){
            if(activity.getID() EQ rc.id){
                rc.result = activity.toStruct();
                return;
            }
        }

        // if not found, abort
        rc.result = CreateObject("component", "model.beans.error").init();
        rc.result.setCode(400);
        rc.result.setMessage("E_ACTIVITY_NOT_FOUND");
    }

    function create(rc){

        var activity = EntityNew("activity");
        var currentmoment = DateConvert("local2UTC", Now());
        var jsondata = {};

        activity.setCreated(LOCAL.currentmoment);
        activity.setMoment(LOCAL.currentmoment);
        activity.setDuration(0);
        activity.setIsRunning(0);
        activity.setIsActive(1);

        try{
            jsondata = DeserializeJSON(GetHttpRequestData().content);

            if( NOT StructKeyExists(jsondata, "description") ){
                throw;
            }
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_MALFORMED_JSON");

            return;
        }

        if( Len(jsondata.description) EQ 0 ){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_ACTIVITY_DESCRIPTION_EMPTY");

            return;
        }

        try{
            activity.setDescription(jsondata.description);

            EntitySave(activity);
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_ACTIVITY_NOT_CREATED");

            return;
        }

        if (StructKeyExists(jsondata, "taskid")){
            try{
                var tasks = rc.user.getTasks();
                for (var task in tasks){
                    if(task.getID() EQ jsondata.taskid){
                        activity.setTask(task);
                        EntitySave(activity);
                    }
                }
            }catch(e){
                // if not found, abort
                rc.result = CreateObject("component", "model.beans.error").init();
                rc.result.setCode(400);
                rc.result.setMessage("E_TASK_NOT_FOUND");

                return;
            }
        }

        try{
            activity.setUser(rc.user);
            EntitySave(activity);
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_ACTIVITY_NOT_ASSOCIATED");

            return;
        }

        rc.result = activity.toStruct();
    }

    function update(rc){

        var activities = rc.user.getActivities();
        var currentmoment = DateConvert("local2UTC", Now());

        param name="rc.id" default="0";

        try {
            jsondata = DeserializeJSON(GetHttpRequestData().content);

            if( NOT StructKeyExists(jsondata, "description") ){
                throw;
            }
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_MALFORMED_JSON");

            return;
        }

        if( Len(jsondata.description) EQ 0 ){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_ACTIVITY_DESCRIPTION_EMPTY");

            return;
        }

        for(var activity in activities){
            if(activity.getID() EQ rc.id){

                activity.setDescription(jsondata.description);
                activity.setMoment(LOCAL.currentmoment);

                if(StructKeyExists(jsondata, "taskid") AND jsondata.taskid GT 0){
                    try{
                        var tasks = rc.user.getTasks();

                        for ( var task in tasks ){
                            if( task.getID() EQ jsondata.taskid ){
                                activity.setTask(task);
                            }
                        }
                    }catch(any e){
                        rc.result = CreateObject("component", "model.beans.error").init();
                        rc.result.setCode(400);
                        rc.result.setMessage("E_TASK_NOT_FOUND");

                        return;
                    }
                }else{
                    try{
                        activity.setTask( JavaCast( "null", 0 ) ); // deassociate activity from task
                    }catch(e){
                        rc.result = CreateObject("component", "model.beans.error").init();
                        rc.result.setCode(400);
                        rc.result.setMessage("E_ACTIVITY_NOT_DEASSOCIATED");

                        return;
                    }
                }

                EntitySave(activity);

                rc.result = activity.toStruct();
                return;
            }
        }

        // if not found, abort
        rc.result = CreateObject("component", "model.beans.error").init();
        rc.result.setCode(400);
        rc.result.setMessage("E_ACTIVITY_NOT_FOUND");
    }

    function delete(rc){

        var activities = rc.user.getActivities();
        var currentmoment = DateConvert("local2UTC", Now());

        param name="rc.id" default="0";

        for (var activity in activities){
            if(activity.getID() EQ rc.id){

                storedproc procedure ="delete_activity" {
                    procparam cfsqltype ="CF_SQL_INTEGER" value ="#rc.user.getID()#";
                    procparam cfsqltype ="CF_SQL_INTEGER" value ="#rc.id#";
                    procparam cfsqltype ="CF_SQL_TIMESTAMP" value ="#LOCAL.currentmoment#";
                    procresult resultset ="1" name ="qryActivity";
                }

                rc.result = QueryToArrayOfStructures(qryActivity)[1];

                if(StructKeyExists(rc.result, "activity_id")){
                    activity = EntityLoadByPK("activity", rc.result.activity_id);

                    rc.result = activity.toStruct();
                    return;
                }else{
                    // if not found, abort
                    rc.result = CreateObject("component", "model.beans.error").init();
                    rc.result.setCode(400);
                    rc.result.setMessage("E_ACTIVITY_NOT_DELETED");
                    return;
                }
            }

        }

        // if not found, abort
        rc.result = CreateObject("component", "model.beans.error").init();
        rc.result.setCode(400);
        rc.result.setMessage("E_ACTIVITY_NOT_FOUND");
    }

    function quickstart(rc){

        var currentmoment = DateConvert("local2UTC", Now());
        var task = {};
        var jsondata = {};

        rc.result = {};

        param name="rc.taskid" default="0"; // comes in url

        if(rc.taskid GT 0){
            try{
                var tasks = rc.user.getTasks();

                for ( var t in tasks ){
                    if( t.getID() EQ rc.taskid ){
                        task = t;
                    }
                }
                if(NOT IsInstanceOf(task, "model.beans.task")){
                    throw;
                }
            }catch(any e){
                // if not found, abort
                rc.result = CreateObject("component", "model.beans.error").init();
                rc.result.setCode(400);
                rc.result.setMessage("E_TASK_NOT_FOUND");

                return;
            }
        }

        try{
            var textdata = GetHttpRequestData().content;

            jsondata = DeserializeJSON(textdata);

            if( NOT StructKeyExists(jsondata, "description") ){
                throw;
            }
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_MALFORMED_JSON");

            return;
        }

        if( Len(jsondata.description) EQ 0 ){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_ACTIVITY_DESCRIPTION_EMPTY");

            return;
        }

        try{

            storedproc procedure="quickstart_activity" {
                procparam cfsqltype="CF_SQL_INTEGER" value="#rc.user.getID()#";
                procparam cfsqltype="CF_SQL_INTEGER" value="#rc.taskid#" null="#rc.taskid EQ 0#"; // 0 = activity without task
                procparam cfsqltype="CF_SQL_VARCHAR" value="#jsondata.description#";
                procparam cfsqltype="CF_SQL_TIMESTAMP" value="#LOCAL.currentmoment#";
                procresult resultset="1" name="qryActivity";
            };

            rc.result = QueryToArrayOfStructures(qryActivity)[1];

            if( StructKeyExists(rc.result, "activity_id") AND rc.result.activity_id GT 0 ){
                var activity = EntityLoadByPK("activity", rc.result.activity_id);

                if(IsInstanceOf(activity, "model.beans.activity")){
                    rc.result = activity.toStruct();
                    return;
                }else{
                    throw;
                }

            }else{
                throw;
            }

        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_ACTIVITY_NOT_QUICKSTARTED");
        }
    }

    function toggle(rc){

        var currentmoment = DateConvert("local2UTC", Now());
        var activities = rc.user.getActivities();

        param name="rc.id" default="0";

        try{
            for(var activity in activities){
                if(activity.getID() EQ rc.id){
                    try{
                        storedproc procedure="toggle_activity" {
                            procparam cfsqltype="CF_SQL_INTEGER" value="#rc.user.getID()#";
                            procparam cfsqltype="CF_SQL_INTEGER" value="#rc.id#";
                            procparam cfsqltype="CF_SQL_TIMESTAMP" value="#LOCAL.currentmoment#";
                            procresult resultset="1" name="qryActivity";
                        }

                        rc.result = QueryToArrayOfStructures(qryActivity)[1];

                        if(StructKeyExists(rc.result, "activity_id")){

                            var structActivity = {
                                                    "created" = THIS.getIsoTimeString(rc.result.activity_created),
                                                    "duration": rc.result.activity_duration,
                                                    "moment": THIS.getIsoTimeString(rc.result.activity_moment),
                                                    "started": THIS.getIsoTimeString(rc.result.activity_started),
                                                    "id": rc.result.activity_id,
                                                    "stopped": THIS.getIsoTimeString(rc.result.activity_stopped),
                                                    "isrunning": rc.result.activity_isrunning,
                                                    "description": rc.result.activity_description
                                                 };

                            if(Len(rc.result.task_id) GT 0){
                                structActivity["task"] = {
                                                            "id": rc.result.task_id,
                                                            "title" = rc.result.task_title
                                                         };
                                if(Len(rc.result.project_id) GT 0){
                                    structActivity["task"]["project"] = {
				                                                            "name": rc.result.project_name,
				                                                            "id": rc.result.project_id
				                                                        };
                                }
                            }

                            rc.result = structActivity;
                            return;
                        }else{
                            throw;
                        }
                    }catch(any e){
                        rc.result = CreateObject("component", "model.beans.error").init();
                        rc.result.setCode(400);
                        rc.result.setMessage("E_ACTIVITY_NOT_TOGGLED");

                        return;
                    }
                }
            }
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_ACTIVITY_NOT_FOUND");
        }
    }

    /**
    * Converts a query object into an array of structures.
    *
    * @param query      The query to be transformed
    * @return This function returns a structure.
    * @author Nathan Dintenfass (nathan@changemedia.com)
    * @version 1, September 27, 2001
    */
    function QueryToArrayOfStructures(theQuery){
        var theArray = arraynew(1);
        var cols = ListToArray(theQuery.columnlist);
        cols = arrayMap(cols, function(c){
            return LCase(c);
        });
        var row = 1;
        var thisRow = "";
        var col = 1;
        for(row = 1; row LTE theQuery.recordcount; row = row + 1){
            thisRow = structnew();
            for(col = 1; col LTE arraylen(cols); col = col + 1){
                thisRow[cols[col]] = theQuery[cols[col]][row];
            }
            arrayAppend(theArray,duplicate(thisRow));
        }
        return(theArray);
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
