component {

    function init(fw){
        variables.fw = fw;
    }

    function welcome(rc){
        var result = structNew();
        result.service = "ttt-api";
        result.version = "1.0.20160624";
        result.release = "Humble";

        getPageContext().getResponse().setHeader( "Access-Control-Allow-Origin", "*" );

        variables.fw.renderData("json", result);
    }

    function error(rc){
        param name="rc.statuscode" default="400";
        if(StructKeyExists(request, "exception")){
            param name="rc.statusmessage" default="#request.exception.type# #request.exception.message# #request.exception.detail#";
        }else{
            param name="rc.statusmessage" default="";
        }

        variables.fw.renderData("text", rc.statusmessage, rc.statuscode);
    }


    public void function send_options_cors(rc){
        getPageContext().getResponse().setHeader( "Access-Control-Allow-Credentials", "true" );
        getPageContext().getResponse().setHeader( "Access-Control-Allow-Origin", "*" );
        getPageContext().getResponse().setHeader( "Access-Control-Allow-Headers", "Authorization" );

        variables.fw.renderData("text", "");
    }

    function stop_dormant_sessions(rc){
        var currentmoment = DateConvert("local2UTC", Now());

        storedproc procedure = "stop_dormant_sessions" {
            procparam cfsqltype = "CF_SQL_INTEGER" value = "20000";
            procparam cfsqltype = "CF_SQL_TIMESTAMP" value = "#LOCAL.currentmoment#";
        }

        variables.fw.renderData("text", "");
    }

    function stop_dormant_activities(rc){
        var currentmoment = DateConvert("local2UTC", Now());

        storedproc procedure = "stop_dormant_activities" {
            procparam cfsqltype = "CF_SQL_INTEGER" value = "2000";
            procparam cfsqltype = "CF_SQL_TIMESTAMP" value = "#LOCAL.currentmoment#";
        }

        variables.fw.renderData("text", "");
    }

    function stop_subscriptions(rc){
        storedproc procedure = "stop_subscriptions";

        variables.fw.renderData("text", "");
    }

}
