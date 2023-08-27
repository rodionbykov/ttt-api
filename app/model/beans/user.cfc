component persistent="true" accessors="true" table="users"{

    // persistent properties

    property name="id" fieldtype="id" generator="native" column="id";
    property name="login" length="45";
    property name="firstname";
    property name="lastname";
    property name="email";
    property name="isactive";

    // dependencies

    property name="subscriber" fieldtype="many-to-one" cfc="subscriber" fkcolumn="id_subscriber" lazy="false";

    property name="roles"
             fieldtype="many-to-many"
             cfc="role"
             linktable="users_x_roles"
             fkcolumn="id_user"
             inversejoincolumn="id_role"
             type="array"
             singularname="role"
             lazy="false";

    property name="projects"
             fieldtype="one-to-many"
             cfc="project"
             fkcolumn="id_user"
             orderby="moment desc"
             where="isactive = 1"
             type="array"
             singularname="project"
             inverse="true"
             lazy="false";

    property name="tasks"
            fieldtype="one-to-many"
            cfc="task"
            fkcolumn="id_user"
            orderby="isrunning desc, moment desc"
            where="isactive = 1"
            type="array"
            singularname="task"
            inverse="true"
            lazy="false";

    property name="activities"
             fieldtype="one-to-many"
             cfc="activity"
             fkcolumn="id_user"
             orderby="isrunning desc, moment desc"
             where="isactive = 1"
             type="array"
             singularname="activity"
             inverse="true"
             lazy="false";

	property name="jots"
             fieldtype="one-to-many"
             cfc="jot"
             fkcolumn="id_user"
             orderby="moment desc"
             where="isactive = 1"
             type="array"
             singularname="jot"
             inverse="true"
             lazy="false";

    // non-persistent properties

    property name="created" persistent="false";
    property name="moment" persistent="false";
    property name="sessiontoken" persistent="false";
    property name="tokens" persistent="false";

    public any function init(){
        VARIABLES.id = 0;
        VARIABLES.tokens = ArrayNew(1);

        return THIS;
    }

    public any function getTokens(){
        return VARIABLES.tokens;
    }

    public any function setTokens(Array arg_tokens){
        // ignoring incoming tokens whatsoever

        VARIABLES.tokens = ArrayNew(1);

        var roles = THIS.getRoles();
        for (var role in roles){
            var tokens = role.getTokens();
            for(var token in tokens){
                ArrayAppend(VARIABLES.tokens, token.getToken());
            }
        }
    }

    public void function addToken(string arg_token){
        ArrayAppend(VARIABLES.tokens, ARGUMENTS.arg_token);
    }

    public boolean function hasToken(string arg_token){
        if(ArrayLen(VARIABLES.tokens) EQ 0){
            THIS.setTokens();
        }
        if (ArrayLen(VARIABLES.tokens) GT 0 AND ArrayFind(VARIABLES.tokens, ARGUMENTS.arg_token)){
            return true;
        }else{
            return false;
        }
    }

    function toStruct(){
        var result = {};

        THIS.setTokens();

        result.id = THIS.getID();
        result.login = THIS.getLogin();
        result.firstname = THIS.getFirstName();
        result.lastname = THIS.getLastName();
        result.email = THIS.getEmail();

        result.tokens = VARIABLES.tokens;

        result.sessiontoken = THIS.getSessionToken();

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