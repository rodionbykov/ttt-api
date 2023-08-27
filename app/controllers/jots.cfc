component {
    pageEncoding "utf-8";

    function init(fw){
        VARIABLES.fw = fw;

        VARIABLES.jsonSerializer = new lib.JsonSerializer()
                                        .asInteger('id')
                                        .asString('body')
                                        .asDate("created")
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
        var jots = rc.user.getJots();

        for (var j in jots){
            ArrayAppend(rc.result, j.toStruct());
        }
    }

}