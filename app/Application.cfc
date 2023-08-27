component extends="lib.org.corfield.framework" {

    this.name = "tttapi" & hash(getCurrentTemplatePath());
    this.sessionManagement = "true";
    this.sessionTimeout = CreateTimeSpan( 0, 8, 0, 0 );
    this.mappings['/org/corfield'] = getDirectoryFromPath(getCurrentTemplatePath()) & "/lib/org/corfield";

    this.datasource = "ttt_api";
    this.ormenabled = true;
    this.ormsettings.cfclocation = "beans";
    this.ormsettings.dialect = "MySQLwithInnoDB";
    this.ormsettings.logSQL = true;

    variables.framework = {
        action = 'do',
        usingSubsystems = false,
        defaultSubsystem = 'home',
        defaultSection = 'home',
        defaultItem = 'welcome',
        subsystemDelimiter = ':',
        siteWideLayoutSubsystem = 'common',
        home = 'home.welcome',
        error = 'home.error',
        reload = 'reload',
        password = 'true',
        reloadApplicationOnEveryRequest = false,
        generateSES = true,
        SESOmitIndex = true,
        baseURL = 'useCgiScriptName',
        suppressImplicitService = true,
        unhandledExtensions = 'cfc',
        unhandledPaths = '/flex2gateway',
        unhandledErrorCaught = false,
        preserveKeyURLKey = 'fw1pk',
        maxNumContextsPreserved = 10,
        cacheFileExists = false,
        applicationKey = 'org.corfield.framework',
        trace = false,
        routes = [
            { "$GET/projects/$" = "/projects/list" },
            { "$GET/projects/:id/$"  = "/projects/get/id/:id" },
            { "$POST/projects/$" = "/projects/create" },
            { "$POST/projects/:id/$" = "/projects/update/id/:id" },
            { "$PUT/projects/:id/$" = "/tasks/quickstart/projectid/:id" },
            { "$DELETE/projects/:id/$" = "/projects/delete/id/:id" },

            { "$GET/tasks/$" = "/tasks/list" },
            { "$GET/tasks/:id/$"  = "/tasks/get/id/:id" },
            { "$POST/tasks/$" = "/tasks/create" },
            { "$POST/tasks/:id/$" = "/tasks/update/id/:id" },
            { "$PUT/tasks/$" = "/tasks/quickstart" },
            { "$PUT/tasks/:id/$" = "/activities/quickstart/taskid/:id" },
            { "$PATCH/tasks/:id/$" = "/tasks/stop/id/:id" },
            { "$DELETE/tasks/:id/$" = "/tasks/delete/id/:id" },

            { "$GET/activities/$" = "/activities/list" },
            { "$GET/activities/:id/$"  = "/activities/get/id/:id" },
            { "$POST/activities/$" = "/activities/create" },
            { "$POST/activities/:id/$" = "/activities/update/id/:id" },
            { "$PUT/activities/$" = "/activities/quickstart" },
            { "$PATCH/activities/:id/$" = "/activities/toggle/id/:id" },
            { "$DELETE/activities/:id/$" = "/activities/delete/id/:id" },

            { "$POST/users/login/$" = "/users/login" },
            { "$GET/users/ping/$" = "/users/ping" },
            { "$OPTIONS/users/ping/$" = "/home/send_options_cors" },
            { "$POST/users/logout/$" = "/users/logout" },
            { "$POST/users/redeem/$" = "/users/redeem" },

            { "$GET/reports/timelog/$" = "/reports/timelog" },
            { "$GET/reports/activity/$" = "/reports/activityreport" },
            { "$GET/reports/summary/$" = "/reports/summaryreport" }
        ]
    };

    function setupApplication(){
        var bf = new org.corfield.ioc('model');
        setBeanFactory(bf);
    }

    function setupRequest(){

        request.context.user = getDefaultBeanFactory().getBean("user").init();

        param name="request.context.userPassToken" default="";
        param name="request.context.subscriberAccessKey" default="";

        param name="URL.s" default="";

        REQUEST.context.subscriberAccessKey = URL.s;

        if(NOT ListFindNoCase("home.welcome,users.login,home.stop_dormant_sessions,home.stop_dormant_activities,home.stop_subscriptions,home.send_options_cors", rc.do)){
            controller("users.pass");
        }
    }

    function onMissingView(){
        return view('home/missing');
    }

}
