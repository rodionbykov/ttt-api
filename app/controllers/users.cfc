component accessors="true" {

    property name="SecurityService";

    function init(fw){
        variables.fw = fw;
    }

    function before(rc){

    }

    function after(rc){
        if (IsDefined("rc.result")){
            if (IsDefined("rc.result") AND IsInstanceOf(rc.result, "model.beans.error")){
                getPageContext().getResponse().setHeader( "Access-Control-Allow-Origin", "*" );
                return variables.fw.renderData("json", rc.result.getMessage(), rc.result.getCode());
            }else{
                return variables.fw.renderData("json", rc.result, 200);
            }
        }
    }

    function login(rc){
        var jsondata = DeserializeJSON(GetHttpRequestData().content);
        param name="rc.subscriberAccessKey" default="";

        var httpRequest = GetHttpRequestData();

        // when login action is called, Authorization header holds login:password
        // where login is user's login and password is hmac-signed user's password
        // subscriber's secred is used as hmac secret argument
        if(StructKeyExists(httpRequest.headers, "Authorization")){
            var auth = StructFind(httpRequest.headers, "Authorization");
            var secCredentials = ListLast(auth, " ");
            var credentials = ToString(ToBinary(secCredentials));

            var username = ListFirst(LOCAL.credentials, ":");
            var passwd = ListLast(LOCAL.credentials, ":");

            var user = VARIABLES.SecurityService.login(username, passwd, rc.subscriberAccessKey);
            // service checks if user's password subscribed with 'subscriber secret' HMAC is same as stored in database

            if(IsInstanceOf(LOCAL.user, "model.beans.user") AND LOCAL.user.getID() GT 0){
                getPageContext().getResponse().setHeader( "Access-Control-Allow-Origin", LOCAL.user.getSubscriber().getAllowOrigin() );
                rc.result = LOCAL.user.toStruct();
            }else{
                rc.result = LOCAL.user; // of type Error
            }

        }else{
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(401);
            rc.result.setMessage("Unauthorized");

            getPageContext().getResponse().setHeader( 'WWW-Authenticate', 'Basic realm="ttt-api"' );
        }

    }

    function fblogin(rc){
        var jsondata = DeserializeJSON(GetHttpRequestData().content);
        var user = VARIABLES.SecurityService.fblogin(jsondata.fbid, jsondata.fbtoken);
        variables.fw.renderData("json", user);
    }

    // method does not return data, only saves user in context
    function pass(rc){
        param name="rc.subscriberAccessKey" default=""; // from Application.cfc
        param name="rc.userPassToken" default=""; // main place to assign user token, ALL requests require PASS first, except those marked in App.cfc

        var httpRequest = GetHttpRequestData();

        if(StructKeyExists(httpRequest.headers, "Authorization")) {

		    var auth = StructFind(httpRequest.headers, "Authorization"); // instead of x-user-pass-token
            var authType = ListFirst(auth, " ");
            var authToken = ListLast(auth, " ");

			if(authType EQ "Bearer"){
				rc.userPassToken = authToken;
			}else{
				rc.result = CreateObject("component", "model.beans.error").init();
	            rc.result.setCode(401);
    	        rc.result.setMessage("Unauthorized");

        	    getPageContext().getResponse().setHeader( "WWW-Authenticate", 'Basic realm="ttt-api"' );
			}

            var user = VARIABLES.SecurityService.pass(rc.subscriberAccessKey, rc.userPassToken);

            if(IsInstanceOf(LOCAL.user, "model.beans.user") AND LOCAL.user.getID() GT 0){
                getPageContext().getResponse().setHeader( "Access-Control-Allow-Origin", LOCAL.user.getSubscriber().getAllowOrigin() );
                rc.user = LOCAL.user;
            }else{
                rc.result = LOCAL.user; // of type error
            }

        }else{
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(401);
            rc.result.setMessage("Unauthorized");

            getPageContext().getResponse().setHeader( "WWW-Authenticate", 'Basic realm="ttt-api"' );
        }
    }

    function ping(rc){
        param name="rc.userPassToken" default="";

        var result = VARIABLES.SecurityService.ping(rc.userPassToken);

        if( IsInstanceOf(LOCAL.result, "model.beans.error") ){
            rc.result = LOCAL.result; // which is of type Error
        }else{
            getPageContext().getResponse().setHeader( "Access-Control-Allow-Origin", LOCAL.result.user.alloworigin );
            StructDelete(LOCAL.result.user, "alloworigin");
            rc.result = LOCAL.result;
        }
    }

    function logout(rc){
        param name="rc.userPassToken" default="";

        var httpRequest = GetHttpRequestData();

        if(StructKeyExists(httpRequest.headers, "Authorization")) {
            rc.userPassToken = StructFind(httpRequest.headers, "Authorization"); // instead of x-user-pass-token

            var user = VARIABLES.SecurityService.logout(rc.userPassToken);

            if(IsInstanceOf(LOCAL.user, "model.beans.user") AND LOCAL.user.getID() GT 0){
                getPageContext().getResponse().setHeader( "Access-Control-Allow-Origin", LOCAL.user.getSubscriber().getAllowOrigin() );
                rc.result = LOCAL.user.toStruct();
            }else{
                rc.result = LOCAL.user; // which is of type Error
            }
        }else{
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(401);
            rc.result.setMessage("Unauthorized");

            getPageContext().getResponse().setHeader( "WWW-Authenticate", 'Basic realm="ttt-api"' );
        }
    }

    function redeem(rc){
        var httpRequest = GetHttpRequestData();
        var jsonPackageToken = {package = ''};

        try{
            var jsonPackageToken = DeserializeJSON(httpRequest.content);
            if(NOT StructKeyExists(jsonPackageToken, "package")){
                throw;
            }
        }catch(any e){
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_MALFORMED_JSON");

            return;
        }

        if(rc.user.hasToken("AdminLoggedIn")){
            storedproc procedure="redeem_package" {
                procparam cfsqltype="cf_sql_varchar" type="in" value="#rc.user.getSubscriber().getID()#";
                procparam cfsqltype="cf_sql_varchar" type="in" value="#jsonPackageToken.package#";
                procresult name="LOCAL.subscriber" resultset=1;
            }
            rc.result = {
                id = LOCAL.subscriber.id,
                name = LOCAL.subscriber.name,
                credits = LOCAL.subscriber.credits
            };
        }else{
            rc.result = CreateObject("component", "model.beans.error").init();
            rc.result.setCode(400);
            rc.result.setMessage("E_ACTION_NOT_ALLOWED");
        }
    }

}
