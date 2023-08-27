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
        var projects = rc.user.getProjects();

        for (var p in projects){
            ArrayAppend(rc.result, p.toStruct());
        }
    }

    function get(rc){
        rc.result = {};
        var projects = rc.user.getProjects();

        for(var project in projects){
            if(project.getID() EQ rc.id){
                rc.result = project.toStruct();
                return;
            }
        }

        // if not found, abort
        rc.result = CreateObject("component", "model.beans.error").init();
        rc.result.setCode(400);
        rc.result.setMessage("E_PROJECT_NOT_FOUND");
    }

    function create(rc){
        var currentmoment = DateConvert("local2UTC", Now());
        var jsondata = {};
        var project = EntityNew("project");

        project.setCreated(LOCAL.currentmoment);
        project.setMoment(LOCAL.currentmoment);
        project.setDuration(0);
        project.setIsActive(1);

        try{
            jsondata = DeserializeJSON(GetHttpRequestData().content);
            if(NOT StructKeyExists(jsondata, "name") OR NOT StructKeyExists(jsondata, "description")){
                throw;
            }
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_MALFORMED_JSON");

            return;
        }

        try{
            if(Len(jsondata.name) GT 0){
                project.setName(jsondata.name);
                project.setDescription(jsondata.description);
            }else{
                throw;
            }
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_PROJECT_NAME_EMPTY");

            return;
        }

        try{
            project.setUser(rc.user);            
            EntitySave(project);
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_TASK_NOT_ASSOCIATED");
            
            return;
        }
        
        rc.result = project.toStruct();
    }

    function update(rc){

        var currentmoment = DateConvert("local2UTC", Now());
        var projects = rc.user.getProjects();
        rc.result = {};

        for(var project in projects){
            if(project.getID() EQ rc.id){
                try{
                    var jsondata = DeserializeJSON(GetHttpRequestData().content);

                    project.setName(jsondata.name);
                    project.setDescription(jsondata.description);
                    project.setMoment(LOCAL.currentmoment);
                    EntitySave(project);

                    rc.result = project.toStruct();
                }catch(any e){
                    rc.result = CreateObject("component", "model.beans.error").init();
                    rc.result.setCode(400);
                    rc.result.setMessage("E_PROJECT_NOT_UPDATED");
                }

                return;
            }
        }

        // if not found, abort
        rc.result = CreateObject("component", "model.beans.error").init();
        rc.result.setCode(400);
        rc.result.setMessage("E_PROJECT_NOT_FOUND");
    }

    function delete(rc){
// TODO use stored procedure here
        var currentmoment = DateConvert("local2UTC", Now());
        var projects = rc.user.getProjects();

        for(var project in projects) {
            if (project.getID() EQ rc.id) {

                // stop activities and tasks
                try {
                    var tasks = project.getTasks();

                    for (var task in tasks){
                        storedproc procedure = "stop_task" {
                            procparam cfsqltype = "CF_SQL_INTEGER" value = "#rc.user.getID()#";
                            procparam cfsqltype = "CF_SQL_INTEGER" value = "#task.getID()#";
                            procparam cfsqltype = "CF_SQL_TIMESTAMP" value = "#LOCAL.currentmoment#";
                            procresult resultset = "1" name = "qryTask";
                        }

                        if(qryTask.RecordCount EQ 1){

                            // de-associate task with project
                            task.setProject(JavaCast( "null", 0 ));
                            EntitySave(task);
                        }else{
                            throw;
                        }
                    }

                } catch (any e){
                    rc.result = CreateObject("component", "model.beans.error").init();
                    rc.result.setCode(400);
                    rc.result.setMessage("E_PROJECT_NOT_STOPPED");

                    return;
                }

                project.setMoment(LOCAL.currentmoment);
                project.setTasks(ArrayNew(1));
                project.setIsActive(0);

                EntitySave(project);

                rc.result = project.toStruct();
                return;
            }
        }

        // if not found, abort
        rc.result = CreateObject("component", "model.beans.error").init();
        rc.result.setCode(400);
        rc.result.setMessage("E_PROJECT_NOT_FOUND");
    }

}