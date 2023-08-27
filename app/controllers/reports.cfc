component {

    function init(fw){
        VARIABLES.fw = fw;

        VARIABLES.jsonSerializer = new lib.JsonSerializer()
                                                        .asInteger('id')
                                                        .asString('name')
                                                        .asString('title')
                                                        .asString('description')
                                                        .asInteger('duration')
                                                        .asBoolean('isrunning')
                                                        .asDate("datestarted")
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
                return variables.fw.renderData("json", rc.result.getMessage(), rc.result.getCode());
            }else{
                return variables.fw.renderData("json", VARIABLES.jsonSerializer.serialize(rc.result), 200);
            }
        }
    }

    function timelog(rc){
        var result = [];
        var jsondata = DeserializeJSON(GetHttpRequestData().content);

        param name="rc.from" default="#DateFormat(Now(), 'yyyy-mm-dd')#";
        param name="rc.to" default="#DateFormat(Now(), 'yyyy-mm-dd')#";

        storedproc procedure="get_time_report" {
            procparam cfsqltype="CF_SQL_INTEGER" value="#rc.user.getID()#";
            procparam cfsqltype="CF_SQL_TIMESTAMP" value="#rc.from#";
            procparam cfsqltype="CF_SQL_TIMESTAMP" value="#rc.to#";
            procparam cfsqltype="CF_SQL_VARCHAR" value="";
            procresult resultset="1" name="qryTimeReport";
        }

        for (tidbit in qryTimeReport){
            var t = { id = tidbit.id,
                      started = THIS.getIsoTimeString(tidbit.started),
                      stopped = THIS.getIsoTimeString(tidbit.stopped),
                      duration = tidbit.duration,
                      datestarted = THIS.getIsoTimeString(tidbit.date_started),
                      activity = {
                                    id = tidbit.id_activity,
                                    description = tidbit.activity_description
                                 }
                    };
            if(tidbit.id_task NEQ ''){
                t.activity.task = {
                            id = tidbit.id_task,
                            title = tidbit.task_title
                         };
                if(tidbit.id_project NEQ ''){
                    t.activity.task.project = {
                                        id = tidbit.id_project,
                                        name = tidbit.project_name
                                     };
                }
            }
            ArrayAppend(result, t);
        }

        rc.result = result;
    }

    function activityreport(rc){
        var result = [];
        var jsondata = DeserializeJSON(GetHttpRequestData().content);

        param name="rc.from" default="#DateFormat(Now(), 'yyyy-mm-dd')#";
        param name="rc.to" default="#DateFormat(Now(), 'yyyy-mm-dd')#";

        storedproc procedure="get_activity_report" {
            procparam cfsqltype="CF_SQL_INTEGER" value="#rc.user.getID()#";
            procparam cfsqltype="CF_SQL_TIMESTAMP" value="#rc.from#";
            procparam cfsqltype="CF_SQL_TIMESTAMP" value="#rc.to#";
            procparam cfsqltype="CF_SQL_VARCHAR" value="";
            procresult resultset="1" name="qryActivityReport";
        };

        for (tidbit in qryActivityReport){
            var t = {
                duration = tidbit.duration,
                datestarted = THIS.getIsoTimeString(tidbit.date_started),
                activity = {
                    id = tidbit.id_activity,
                    description = tidbit.activity_description
                }
            };

            if(tidbit.id_task NEQ ''){
                t.activity.task = {
                    id = tidbit.id_task,
                    title = tidbit.task_title
                };

                if(tidbit.id_project NEQ ''){
                    t.activity.task.project = {
                        id = tidbit.id_project,
                        name = tidbit.project_name
                    };
                }
            }

            ArrayAppend(result, t);
        }

        rc.result = result;
    }

    function summaryreport(rc){
        var result = [];
        var jsondata = DeserializeJSON(GetHttpRequestData().content);

        param name="rc.from" default="#DateFormat(Now(), 'yyyy-mm-dd')#";
        param name="rc.to" default="#DateFormat(Now(), 'yyyy-mm-dd')#";

        storedproc procedure="get_summary_report" {
            procparam cfsqltype="CF_SQL_INTEGER" value="#rc.user.getID()#";
            procparam cfsqltype="CF_SQL_TIMESTAMP" value="#rc.from#";
            procparam cfsqltype="CF_SQL_TIMESTAMP" value="#rc.to#";
            procparam cfsqltype="CF_SQL_VARCHAR" value="";
            procresult resultset="1" name="qrySummaryReport";
        };

        for (tidbit in qrySummaryReport){
            var t = {
                duration = tidbit.duration,
                activity = {
                    id = tidbit.id_activity,
                    description = tidbit.activity_description
                }
            };

            if(tidbit.id_task NEQ ''){
                t.activity.task = {
                    id = tidbit.id_task,
                    title = tidbit.task_title
                };

                if(tidbit.id_project NEQ ''){
                    t.activity.task.project = {
                        id = tidbit.id_project,
                        name = tidbit.project_name
                    };
                }
            }

            ArrayAppend(result, t);
        }

        rc.result = result;
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
