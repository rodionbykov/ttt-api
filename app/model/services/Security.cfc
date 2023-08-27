<cfcomponent output="false">

    <cffunction name="init" access="public" returntype="any" output="false">
        <cfreturn THIS />
    </cffunction>

    <cffunction name="login" output="false" hint="Login action" returntype="any">
        <cfargument name="arg_login" required="true" type="string" />
        <cfargument name="arg_password" required="true" type="string" />
        <cfargument name="arg_accesskey" required="true" type="string" />

        <cfset var result = {} />

        <cfset var qryUser = "" />
        <cfset var qrySubscriber = "" />

        <cfset var currentmoment = DateConvert("local2UTC", Now()) />

        <cfstoredproc procedure="usp_login">
            <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.arg_login#" />
            <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.arg_password#" />
            <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.arg_accesskey#" />
            <cfprocparam type="in" cfsqltype="CF_SQL_TIMESTAMP" value="#LOCAL.currentmoment#" />
            <cfprocresult name="qryUser" resultset="1" />
            <cfprocresult name="qrySubscriber" resultset="2" />
        </cfstoredproc>

        <cfif qryUser.RecordCount EQ 1>
            <cfset result = EntityLoadByPK("user", qryUser.id) />
            <cfset result.setCreated(qryUser.created) />
            <cfset result.setMoment(qryUser.moment) />
            <cfset result.setSessionToken(qryUser.sessiontoken) />
            <cfset result.setTokens() /> <!--- tokens taken from roles --->

            <cfif qrySubscriber.RecordCount EQ 0>
                <cfset result = CreateObject("component", "model.beans.error").init() />
                <cfset result.setCode(400) />
                <cfset result.setMessage("E_SUBSCRIBER_NOT_FOUND") />
            <cfelse>
                <cfif arg_accesskey NEQ qrySubscriber.accesskey>
                    <cfset result = CreateObject("component", "model.beans.error").init() />
                    <cfset result.setCode(400) />
                    <cfset result.setMessage("E_SUBSCRIBER_NOT_MATCH") />
                </cfif>
            </cfif>
        <cfelse>
            <cfset result = CreateObject("component", "model.beans.error").init() />
            <cfset result.setCode(400) />
            <cfset result.setMessage("E_USER_NOT_FOUND") />
        </cfif>

        <cfreturn result />
    </cffunction>

    <cffunction name="fblogin" output="false" hint="OAuth login action" returntype="Struct">
        <cfargument name="arg_fbid" required="true" type="string" />
        <cfargument name="arg_fbtoken" required="true" type="string" />

        <cfset var qryUser = "" />
        <cfset var qryRoles = "" />
        <cfset var qryTokens = "" />
        <cfset var fb_user = {id: 0, username: '', name: '', first_name: '', last_name: '', gender: '', link: '', locale: ''} />
        <cfset var user = { id: 0, login: '', firstname: '', lastname: '', email: '', moment: '', lastactionmoment: '', sessiontoken: '', usersession_isactive: 0, roles: [], tokens: [] } />
        <cfset var role = { id: 0,  pluralname: '', singularname: ''} />
        <cfset var token = { id: 0,  token: ''} />

        <cftry>
            <cfset var facebookGraphAPI = new FacebookGraphAPI(accessToken = ARGUMENTS.arg_fbtoken, appId = "") />
            <cfset var userObject = facebookGraphAPI.getObject(id = ARGUMENTS.arg_fbid) />

            <cfif structKeyExists(userObject, "id")>
                <cfset fb_user.id = userObject.id>
            </cfif>
            <cfif structKeyExists(userObject, "username")>
                <cfset fb_user.username = userObject.username>
            </cfif>
            <cfif structKeyExists(userObject, "name")>
                <cfset fb_user.name = userObject.name>
            </cfif>
            <cfif structKeyExists(userObject, "first_name")>
                <cfset fb_user.first_name = userObject.first_name>
            </cfif>
            <cfif structKeyExists(userObject, "last_name")>
                <cfset fb_user.last_name = userObject.last_name>
            </cfif>
            <cfif structKeyExists(userObject, "gender")>
                <cfset fb_user.gender = userObject.gender>
            </cfif>
            <cfif structKeyExists(userObject, "link")>
                <cfset fb_user.link = userObject.link>
            </cfif>
            <cfif structKeyExists(userObject, "locale")>
                <cfset fb_user.locale = userObject.locale>
            </cfif>

            <!--- call login safely, as user was authenticated by fb --->
            <cfstoredproc procedure="usp_oauth_login">
                <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#fb_user.id#" />
                <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="fb" />
                <cfprocresult name="qryUser" resultset="1" />
                <cfprocresult name="qryRoles" resultset="2" />
                <cfprocresult name="qryTokens" resultset="3" />
            </cfstoredproc>

            <!--- if not logged in, register with fb credentials --->
            <cfif qryUser.RecordCount EQ 0>
                <cfstoredproc procedure="usp_oauth_register">
                    <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#fb_user.id#" />
                    <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="fb" />
                    <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#fb_user.username#" />
                    <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#fb_user.first_name#" />
                    <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#fb_user.last_name#" />
                    <cfprocresult name="qryUser" resultset="1" />
                    <cfprocresult name="qryRoles" resultset="2" />
                    <cfprocresult name="qryTokens" resultset="3" />
                </cfstoredproc>
            </cfif>

            <cfif qryUser.recordcount eq 1>
                <cfset user.id = qryUser.id />
                <cfset user.login = qryUser.login />
                <cfset user.firstname = qryUser.firstname />
                <cfset user.lastname = qryUser.lastname />
                <cfset user.email = qryUser.email />
                <cfset user.sessiontoken = qryUser.sessiontoken />
                <cfset user.moment = qryUser.moment />
                <cfset user.lastactionmoment = qryUser.lastactionmoment />
                <cfset user.usersession_isactive = qryUser.usersession_isactive />

                <cfloop query="qryRoles">
                    <cfset role = structNew() />
                    <cfset role.id = qryRoles.id />
                    <cfset role.pluralname = qryRoles.pluralname />
                    <cfset role.singularname = qryRoles.singularname />
                    <cfset arrayAppend(user.roles, role) />
                </cfloop>

                <cfloop query="qryTokens">
                    <cfset token = structNew() />
                    <cfset token.id = qryTokens.id />
                    <cfset token.token = qryTokens.token />
                    <cfset arrayAppend(user.tokens, token) />
                </cfloop>
            </cfif>

            <cfreturn user />
            <cfcatch>
                <cfsavecontent variable="err" >
                    <cfdump var='#cfcatch#' />
                </cfsavecontent>
                <cffile action="write" file="#ExpandPath("err.html")#" output="#err#" />
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="register" output="false" hint="Register user" returntype="Struct">
        <cfargument name="arg_login" required="true" type="string" />
        <cfargument name="arg_password" required="true" type="string" />
        <cfargument name="arg_email" required="true" type="string" />
        <cfargument name="arg_firstname" required="false" type="string" default="" />
        <cfargument name="arg_lastname" required="false" type="string" default="" />

        <cfset var qryUser = "" />
        <cfset var qryRoles = "" />
        <cfset var res = { id: 0, login: '', firstname: '', lastname: '', email: '', moment: '', lastactionmoment: '', sessiontoken: '', usersession_isactive: 0, roles: [], tokens: [] } />

        <cfstoredproc procedure="usp_register">
            <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.arg_login#" />
            <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#Hash(ARGUMENTS.arg_password)#" />
            <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.arg_email#" />
            <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.arg_firstname#" />
            <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.arg_lastname#" />
            <cfprocresult name="qryUser" resultset="1" />
            <cfprocresult name="qryRoles" resultset="2" />
        </cfstoredproc>

        <cfif qryUser.recordcount eq 1>
            <cfset res.id = qryUser.id />
            <cfset res.login = qryUser.login />
            <cfset res.firstname = qryUser.firstname />
            <cfset res.lastname = qryUser.lastname />
            <cfset res.email = qryUser.email />
            <cfset res.sessiontoken = qryUser.sessiontoken />
            <cfset res.moment = qryUser.moment />
            <cfset res.lastactionmoment = qryUser.lastactionmoment />
        </cfif>

        <cfreturn res />
    </cffunction>

    <cffunction name="pass" output="false" hint="Passing into system" returntype="any">
        <cfargument name="arg_accesskey" required="true" type="string" />
        <cfargument name="arg_sessiontoken" required="true" type="string" />

        <cfset var result = {} />

        <cfset var qryUser = "" />
        <cfset var qrySubscriber = "" />

        <cfset var currentmoment = DateConvert("local2UTC", Now()) />

        <cfstoredproc procedure="usp_pass">
            <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.arg_sessiontoken#" />
            <cfprocparam type="in" cfsqltype="CF_SQL_TIMESTAMP" value="#LOCAL.currentmoment#" />
            <cfprocresult name="qryUser" resultset="1" />
            <cfprocresult name="qrySubscriber" resultset="2" />
        </cfstoredproc>

        <cfif qryUser.RecordCount EQ 1>
            <cfset result = EntityLoadByPK("user", qryUser.id) />
            <cfset result.setCreated(qryUser.created) />
            <cfset result.setMoment(qryUser.moment) />
            <cfset result.setSessionToken(qryUser.sessiontoken) />
            <cfset result.setTokens() /> <!--- tokens taken from roles --->

            <cfif qrySubscriber.RecordCount EQ 0>
                <cfset result = CreateObject("component", "model.beans.error").init() />
                <cfset result.setCode(400) />
                <cfset result.setMessage("E_SUBSCRIBER_NOT_FOUND") />
            <cfelse>
                <cfif arg_accesskey NEQ qrySubscriber.accesskey>
                    <cfset result = CreateObject("component", "model.beans.error").init() />
                    <cfset result.setCode(400) />
                    <cfset result.setMessage("E_SUBSCRIBER_NOT_MATCH") />
                </cfif>
            </cfif>
        <cfelse>
            <cfset result = CreateObject("component", "model.beans.error").init() />
            <cfset result.setCode(400) />
            <cfset result.setMessage("E_USER_NOT_FOUND") />
        </cfif>

        <cfset ulog(qryUser.sessiontoken, REQUEST.context.do, 'Passed') />
        <cfreturn result />
    </cffunction>

    <cffunction name="ulog" output="false" hint="Logging user's actions">
        <cfargument name="arg_sessiontoken" required="true" type="string" />
        <cfargument name="arg_useraction" required="true" type="string" />
        <cfargument name="arg_description" required="false" type="string" />

        <cfset var currentmoment = DateConvert("local2UTC", Now()) />

        <cfstoredproc procedure="usp_log">
            <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.arg_sessiontoken#" />
            <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.arg_useraction#" />
            <cfprocparam type="in" cfsqltype="CF_SQL_LONGVARCHAR" value="#ARGUMENTS.arg_description#" />
            <cfprocparam type="in" cfsqltype="CF_SQL_TIMESTAMP" value="#LOCAL.currentmoment#" />
        </cfstoredproc>

    </cffunction>

    <cffunction name="ping" output="false" hint="Pinging user into system" returntype="Struct">
        <cfargument name="arg_sessiontoken" required="true" type="string" />

        <cfset var qryUser = "" />
        <cfset var qryActivity = "" />
        <cfset var result = {} />

        <cfset var currentmoment = DateConvert("local2UTC", Now()) />

        <cfstoredproc procedure="usp_ping">
            <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.arg_sessiontoken#" />
            <cfprocparam type="in" cfsqltype="CF_SQL_TIMESTAMP" value="#LOCAL.currentmoment#" />
            <cfprocresult name="qryUser" resultset="1" />
            <cfprocresult name="qryActivity" resultset="2" />
        </cfstoredproc>

        <cfif qryUser.RecordCount EQ 1>
            <cfset result.user = {} />
            <cfset result.user.id = qryUser.id />
            <cfset result.user.login = qryUser.login />
            <cfset result.user.firstname = qryUser.firstname />
            <cfset result.user.lastname = qryUser.lastname />
            <cfset result.user.email = qryUser.email />
            <cfset result.user.alloworigin = qryUser.alloworigin />
            <cfif qryActivity.RecordCount EQ 1>
                <cfset result.activity = EntityLoadByPK("activity", qryActivity.activity_id).toStruct() />
            </cfif>
        <cfelse>
            <cfset result = CreateObject("component", "model.beans.error").init() />
            <cfset result.setCode(400) />
            <cfset result.setMessage("E_USER_NOT_PINGED") />
        </cfif>

        <cfreturn result />
    </cffunction>

    <cffunction name="logout" output="false" hint="Log out action" returntype="Struct">
        <cfargument name="arg_sessiontoken" required="true" type="string" />

        <cfset var result = {} />

        <cfset var currentmoment = DateConvert("local2UTC", Now()) />

        <cfstoredproc procedure="usp_logout">
            <cfprocparam type="in" cfsqltype="CF_SQL_VARCHAR" value="#ARGUMENTS.arg_sessiontoken#" />
            <cfprocparam type="in" cfsqltype="CF_SQL_TIMESTAMP" value="#LOCAL.currentmoment#" />
            <cfprocresult name="qrySession" resultset="1" />
        </cfstoredproc>

        <cfif qrySession.RecordCount EQ 1>
            <cfset result = EntityLoadByPK("user", qrySession.id) />
            <cfset result.setCreated(qrySession.created) />
            <cfset result.setMoment(qrySession.moment) />
            <cfset result.setSessionToken(qrySession.sessiontoken) />
            <cfset result.setTokens() /> <!--- tokens taken from roles --->
        <cfelse>
            <cfset result = CreateObject("component", "model.beans.error").init() />
            <cfset result.setCode(400) />
            <cfset result.setMessage("E_SESSION_NOT_FOUND") />
        </cfif>

        <cfreturn result />
    </cffunction>

</cfcomponent>