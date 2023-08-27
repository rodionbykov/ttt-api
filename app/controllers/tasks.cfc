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
        var tasks = rc.user.getTasks();

        for (var t in tasks){
            ArrayAppend(rc.result, t.toStruct());
        }
    }

    function get(rc){
        var result = {};
        var tasks = rc.user.getTasks();

        param name="rc.id" default="0";

        for (var task in tasks){
            if(task.getID() EQ rc.id){
                rc.result = task.toStruct();
                return;
            }
        }

        // if not found, abort
        rc.result = CreateObject("component", "model.beans.error").init();
        rc.result.setCode(400);
        rc.result.setMessage("E_TASK_NOT_FOUND");
    }

    function create(rc){

        rc.result = {};
        var jsondata = {};
        var task = EntityNew("task");
        var currentmoment = DateConvert("local2UTC", Now());

        task.setCreated(LOCAL.currentmoment);
        task.setMoment(LOCAL.currentmoment);
        task.setDuration(0);
        task.setIsRunning(0);
        task.setIsActive(1);

        try{
            var jsondata = DeserializeJSON(GetHttpRequestData().content);
            if(NOT StructKeyExists(jsondata, "title") OR NOT StructKeyExists(jsondata, "description")){
                throw;
            }
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_MALFORMED_JSON");

            return;
        }

        try{
            if(Len(jsondata.title) GT 0){
                task.setTitle(jsondata.title);
                task.setDescription(jsondata.description);

                EntitySave(task);
            }else{
                throw;
            }
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_TASK_TITLE_EMPTY");

            return;
        }

        try{
            task.setUser(rc.user);
            EntitySave(task);
        }catch(e){
            // if not found, abort
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_TASK_NOT_ASSOCIATED");

            return;
        }

        if (StructKeyExists(jsondata, "projectid") AND IsNumeric(jsondata.projectid)){
            try{
                var projects = rc.user.getProjects();
                for (var project in projects){
                    if(project.getID() EQ jsondata.projectid){
                        task.setProject(project);
                        EntitySave(task);
                    }
                }
            }catch(e){
                // if not found, abort
                rc.result = CreateObject("component", "model.beans.error").init();
                rc.result.setCode(400);
                rc.result.setMessage("E_PROJECT_NOT_FOUND");

                return;
            }
        }

        rc.result = task.toStruct();
    }

    function update(rc){

        var tasks = rc.user.getTasks();
        var currentmoment = DateConvert("local2UTC", Now());
        var jsondata = {};

        rc.result = {};
        rc.task = {};

        try{
            for(var task in tasks){
                if(task.getID() EQ rc.id){
                    rc.task = task;
                }
            }
            if ( NOT IsInstanceOf(rc.task, "model.beans.task") ){
                throw;
            }
        }catch(any e){
            // if not found, abort
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_TASK_NOT_FOUND");

            return;
        }

        try{
            jsondata = DeserializeJSON(GetHttpRequestData().content);
            if(NOT StructKeyExists(jsondata, "title") OR NOT StructKeyExists(jsondata, "description")){
                throw;
            }
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_MALFORMED_JSON");

            return;
        }

        try{
            if(Len(jsondata.title) GT 0){

                rc.task.setTitle(jsondata.title);
                rc.task.setDescription(jsondata.description);
                rc.task.setMoment(LOCAL.currentmoment);

                EntitySave(rc.task);
            }else{
                throw;
            }
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_TASK_TITLE_EMPTY");

            return;
        }

        if (StructKeyExists(jsondata, "projectid") AND IsNumeric(jsondata.projectid) AND jsondata.projectid GT 0){
            try{
                var projects = rc.user.getProjects();
                for (var project in projects){
                    if(project.getID() EQ jsondata.projectid){
                        rc.task.setProject(project);

                        EntitySave(rc.task);
                    }
                }
            }catch(e){
                // if not found, abort
                rc.result = CreateObject("component", "model.beans.error").init();
                rc.result.setCode(400);
                rc.result.setMessage("E_PROJECT_NOT_FOUND");

                return;
            }
        }else{
            try{
                rc.task.setProject( JavaCast( "null", 0 ) ); // deassociate task from project
                EntitySave(rc.task);
            }catch(e){
                // if not found, abort
                rc.result = CreateObject("component", "model.beans.error").init();
                rc.result.setCode(400);
                rc.result.setMessage("E_TASK_NOT_DEASSOCIATED");

                return;
            }
        }

        rc.result = rc.task.toStruct(); //TODO rewrite this method like others, without awkward checks
    }

    function delete(rc){
        // TODO use stored procedure to stop and remove task
        var tasks = rc.user.getTasks();
        var currentmoment = DateConvert("local2UTC", Now());

        param name="rc.id" default="0";

        for (var task in tasks){
            if(task.getID() EQ rc.id){

                try{
                    storedproc procedure="stop_task" {
                        procparam cfsqltype="CF_SQL_INTEGER" value="#rc.user.getID()#";
                        procparam cfsqltype="CF_SQL_INTEGER" value="#task.getID()#";
                        procparam cfsqltype="CF_SQL_TIMESTAMP" value="#LOCAL.currentmoment#";
                        procresult resultset="1" name="qryTask";
                    }
                }catch(any e){
                    rc.result = CreateObject("component", "model.beans.error").init();
                    rc.result.setCode(400);
                    rc.result.setMessage("E_TASK_NOT_STOPPED");

                    return;
                }

                try{

                    for(var activity in task.getActivities()){
                        activity.setIsActive(0);
                        EntitySave(activity);
                    }

                }catch(any e){
                    rc.result = CreateObject("component", "model.beans.error").init();
                    rc.result.setCode(400);
                    rc.result.setMessage("E_ACTIVITIES_NOT_DELETED");

                    return;
                }

                task.setIsActive(0);
                task.setMoment(LOCAL.currentmoment);
                EntitySave(task);

                rc.result = task.toStruct();
                return;
            }
        }

        // if not found, abort
        rc.result = CreateObject("component", "model.beans.error").init();
        rc.result.setCode(400);
        rc.result.setMessage("E_TASK_NOT_FOUND");
    }

    function quickstart(rc){

        var currentmoment = DateConvert("local2UTC", Now());
        var project = {};
        var jsondata = {};

        rc.result = {};

        param name="rc.projectid" default="0";

        try{
            jsondata = DeserializeJSON(GetHttpRequestData().content);

            if(NOT StructKeyExists(jsondata, "title") OR NOT StructKeyExists(jsondata, "description")){
                throw;
            }

            if( StructKeyExists(jsondata, "projectid") AND isNumeric(jsondata.projectid) ){
                rc.projectid = jsondata.projectid;
            }

        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_MALFORMED_JSON");

            return;
        };

        if(rc.projectid GT 0){
            try{
                var projects = rc.user.getProjects();

                for ( var p in projects ){
                    if( p.getID() EQ rc.projectid ){
                        project = p;
                    }
                }
                if(NOT IsInstanceOf(project, "model.beans.project")){
                    throw;
                }
            }catch(any e){
                // if not found, abort
                rc.result = CreateObject("component", "model.beans.error").init();
                rc.result.setCode(400);
                rc.result.setMessage("E_PROJECT_NOT_FOUND");

                return;
            }
        }

        if( Len(jsondata.title) EQ 0 ){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_TASK_TITLE_EMPTY");

            return;
        }

        if( Len(jsondata.description) EQ 0 ){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_ACTIVITY_DESCRIPTION_EMPTY");

            return;
        }

        try{

            storedproc procedure="quickstart_task" {
                procparam cfsqltype="CF_SQL_INTEGER" value="#rc.user.getID()#";
                procparam cfsqltype="CF_SQL_INTEGER" value="#rc.projectid#" null="#rc.projectid EQ 0#"; // 0 = task without project
                procparam cfsqltype="CF_SQL_VARCHAR" value="#jsondata.title#";
                procparam cfsqltype="CF_SQL_VARCHAR" value="#jsondata.description#";
                procparam cfsqltype="CF_SQL_TIMESTAMP" value="#LOCAL.currentmoment#";
                procresult resultset="1" name="qryActivity";
            }

            rc.result = QueryToArrayOfStructures(qryActivity)[1];

            if( StructKeyExists(rc.result, "activity_id") AND rc.result.activity_id GT 0 ){
                var activity = EntityLoadByPK("activity", rc.result.activity_id);

                if(IsInstanceOf(activity, "model.beans.activity")){
                    rc.result = activity.toStruct();
                }else{
                    throw;
                }

            }else{
                throw;
            }
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_TASK_NOT_QUICKSTARTED");

            return;
        }
    }

    function stop(rc){

        var currentmoment = DateConvert("local2UTC", Now());
        param name="rc.id" default="0";
        rc.result = {};

        if(rc.id GT 0){
            var tasks = rc.user.getTasks();

            for ( var task in tasks ){
                if( task.getID() EQ rc.id ){

                    try{

                        storedproc procedure="stop_task" {
                            procparam cfsqltype="CF_SQL_INTEGER" value="#rc.user.getID()#";
                            procparam cfsqltype="CF_SQL_INTEGER" value="#rc.id#";
                            procparam cfsqltype="CF_SQL_TIMESTAMP" value="#LOCAL.currentmoment#";
                            procresult resultset="1" name="qryTask";
                        }

                        var structTask = QueryToArrayOfStructures(qryTask)[1];

                        rc.result = {
		                                "created" = THIS.getIsoTimeString(structTask.created),
		                                "duration" = structTask.duration,
		                                "moment" = THIS.getIsoTimeString(structTask.moment),
		                                "id" = structTask.id,
		                                "isrunning" = structTask.isrunning,
		                                "title" = structTask.title,
		                                "description" = structTask.description
		                            };

                        if(Len(structTask.id_project) GT 0){
                            rc.result["project"] = {
                                "name" = structTask.project_name,
                                "id" = structTask.id_project
                            };
                        };

                        return;
                    }catch (any e){
                        rc.result = CreateObject("component", "model.beans.error").init();
                        rc.result.setCode(400);
                        rc.result.setMessage("E_TASK_NOT_STOPPED");
                        return;
                    }
                }
            }
        }

        // if not found, abort
        rc.result = CreateObject("component", "model.beans.error").init();
        rc.result.setCode(400);
        rc.result.setMessage("E_TASK_NOT_FOUND");
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