# Project: where all Tasks live

**P. is a top-level grouping element**

 * Groups tasks
 * Calculates summary time per all tasks included

## Get projects

*Returns array of Projects, with all their Tasks and each Task has all Activities*

### Request

~~~json
GET /v1/s-00001-almagro/projects/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Host: demo.local
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

[{
    "created": "2014-12-23T22:18:57Z",
    "tasks": [{
        "created": "2013-12-23T22:23:08Z",
        "duration": 70,
        "moment": "2016-02-21T21:33:48Z",
        "activities": [{
            "created": "",
            "duration": 70,
            "moment": "2016-02-21T21:33:48Z",
            "started": "2016-01-25T20:33:16Z",
            "id": 68,
            "stopped": "2016-02-21T21:33:48Z",
            "isrunning": 0,
            "description": "test",
            "task": {
                "project": {
                    "name": "Project BETA",
                    "id": 2
                },
                "id": 7,
                "title": "Investigate compatibility"
            }
        }],
        "project": {
            "name": "Project BETA",
            "id": 2
        },
        "id": 7,
        "isrunning": 0,
        "title": "Investigate compatibility",
        "description": ""
    }, {
        "created": "2013-12-23T22:23:08Z",
        "duration": 0,
        "moment": "2016-01-10T20:48:32Z",
        "project": {
            "name": "Project BETA",
            "id": 2
        },
        "id": 8,
        "isrunning": 0,
        "title": "Investigate capabilities",
        "description": ""
    }, {
        "created": "2014-02-05T19:33:25Z",
        "duration": 50235448,
        "moment": "2015-09-16T09:57:28Z",
        "activities": [{
            "created": "",
            "duration": 50235448,
            "moment": "2015-09-16T09:57:28Z",
            "started": "2014-02-11T23:40:00Z",
            "id": 42,
            "stopped": "2015-09-16T09:57:28Z",
            "isrunning": 0,
            "description": "Creating Some tickets",
            "task": {
                "project": {
                    "name": "Project BETA",
                    "id": 2
                },
                "id": 27,
                "title": "new task from api 5"
            }
        }],
        "project": {
            "name": "Project BETA",
            "id": 2
        },
        "id": 27,
        "isrunning": 0,
        "title": "new task from api 5",
        "description": "task description"
    }],
    "duration": 50235518,
    "moment": "2014-12-23T22:18:57Z",
    "name": "Project BETA",
    "id": 2,
    "description": "Second project "
}]
~~~

Get Project
---

_Returns one Project and all its Tasks with Activities_

### Request

~~~json
GET /v1/s-00001-almagro/projects/1/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Host: demo.local
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2014-12-23T22:18:57Z",
    "tasks": [{
        "created": "2016-02-19T07:19:59Z",
        "duration": 0,
        "moment": "2016-02-19T07:19:59Z",
        "project": {
            "name": "Project ALPHA",
            "id": 1
        },
        "id": 48,
        "isrunning": 0,
        "title": "Test task new2",
        "description": "qweqwe"
    }, {
        "created": "2015-09-08T12:39:08Z",
        "duration": 10742,
        "moment": "2016-01-24T22:17:42Z",
        "activities": [{
            "created": "",
            "duration": 9621,
            "moment": "2016-01-24T22:17:42Z",
            "started": "2016-01-17T20:38:20Z",
            "id": 64,
            "stopped": "2016-01-24T22:17:42Z",
            "isrunning": 0,
            "description": "Some old task",
            "task": {
                "project": {
                    "name": "Project ALPHA",
                    "id": 1
                },
                "id": 29,
                "title": "New title"
            }
        }, {
            "created": "",
            "duration": 1121,
            "moment": "2016-01-17T20:37:31Z",
            "started": "2016-01-17T20:18:50Z",
            "id": 63,
            "stopped": "2016-01-17T20:37:31Z",
            "isrunning": 0,
            "description": "Rest",
            "task": {
                "project": {
                    "name": "Project ALPHA",
                    "id": 1
                },
                "id": 29,
                "title": "New title"
            }
        }],
        "project": {
            "name": "Project ALPHA",
            "id": 1
        },
        "id": 29,
        "isrunning": 0,
        "title": "New title",
        "description": "New Description"
    }, {
        "created": "2013-12-23T22:23:08Z",
        "duration": 0,
        "moment": "2015-09-16T09:57:28Z",
        "activities": [{
            "created": "",
            "duration": 0,
            "moment": "2015-09-16T09:57:28Z",
            "started": "2013-05-01T12:00:00Z",
            "id": 5,
            "stopped": "2015-09-16T09:57:28Z",
            "isrunning": 0,
            "description": "basic methods",
            "task": {
                "project": {
                    "name": "Project ALPHA",
                    "id": 1
                },
                "id": 3,
                "title": "Implement basic methods"
            }
        }, {
            "created": "",
            "duration": 0,
            "moment": "2015-09-16T09:57:28Z",
            "started": "2013-05-01T12:00:00Z",
            "id": 6,
            "stopped": "2015-09-16T09:57:28Z",
            "isrunning": 0,
            "description": "select method",
            "task": {
                "project": {
                    "name": "Project ALPHA",
                    "id": 1
                },
                "id": 3,
                "title": "Implement basic methods"
            }
        }, {
            "created": "",
            "duration": 0,
            "moment": "2015-09-16T09:57:28Z",
            "started": "2013-05-01T12:00:00Z",
            "id": 7,
            "stopped": "2015-09-16T09:57:28Z",
            "isrunning": 0,
            "description": "select method",
            "task": {
                "project": {
                    "name": "Project ALPHA",
                    "id": 1
                },
                "id": 3,
                "title": "Implement basic methods"
            }
        }, {
            "created": "",
            "duration": 0,
            "moment": "2015-09-16T09:57:28Z",
            "started": "2013-05-01T12:00:00Z",
            "id": 9,
            "stopped": "2015-09-16T09:57:28Z",
            "isrunning": 0,
            "description": "qwertyuiop",
            "task": {
                "project": {
                    "name": "Project ALPHA",
                    "id": 1
                },
                "id": 3,
                "title": "Implement basic methods"
            }
        }],
        "project": {
            "name": "Project ALPHA",
            "id": 1
        },
        "id": 3,
        "isrunning": 0,
        "title": "Implement basic methods",
        "description": ""
    }, {
        "created": "2013-12-23T22:23:08Z",
        "duration": 0,
        "moment": "2015-09-16T09:57:28Z",
        "activities": [{
            "created": "",
            "duration": 0,
            "moment": "2015-09-16T09:57:28Z",
            "started": "2013-05-01T12:00:00Z",
            "id": 10,
            "stopped": "2015-09-16T09:57:28Z",
            "isrunning": 0,
            "description": "new activity",
            "task": {
                "project": {
                    "name": "Project ALPHA",
                    "id": 1
                },
                "id": 4,
                "title": "Implement database"
            }
        }, {
            "created": "",
            "duration": 0,
            "moment": "2015-09-16T09:57:28Z",
            "started": "2013-05-01T12:00:00Z",
            "id": 16,
            "stopped": "2015-09-16T09:57:28Z",
            "isrunning": 0,
            "description": "new activity",
            "task": {
                "project": {
                    "name": "Project ALPHA",
                    "id": 1
                },
                "id": 4,
                "title": "Implement database"
            }
        }, {
            "created": "",
            "duration": 0,
            "moment": "2015-09-16T09:57:28Z",
            "started": "2013-05-01T12:00:00Z",
            "id": 17,
            "stopped": "2015-09-16T09:57:28Z",
            "isrunning": 0,
            "description": "home screen",
            "task": {
                "project": {
                    "name": "Project ALPHA",
                    "id": 1
                },
                "id": 4,
                "title": "Implement database"
            }
        }],
        "project": {
            "name": "Project ALPHA",
            "id": 1
        },
        "id": 4,
        "isrunning": 0,
        "title": "Implement database",
        "description": ""
    }, {
        "created": "2015-09-08T18:53:02Z",
        "duration": 50330100,
        "moment": "2015-09-16T09:57:28Z",
        "activities": [{
            "created": "",
            "duration": 50330100,
            "moment": "2015-09-16T09:57:28Z",
            "started": "2014-02-18T22:53:46Z",
            "id": 44,
            "stopped": "2015-09-16T09:57:28Z",
            "isrunning": 0,
            "description": "",
            "task": {
                "project": {
                    "name": "Project ALPHA",
                    "id": 1
                },
                "id": 30,
                "title": "Some Title"
            }
        }],
        "project": {
            "name": "Project ALPHA",
            "id": 1
        },
        "id": 30,
        "isrunning": 0,
        "title": "Some Title",
        "description": "Some Description"
    }],
    "duration": 50340842,
    "moment": "2014-12-23T22:18:57Z",
    "name": "Project ALPHA",
    "id": 1,
    "description": "First project"
}
~~~

Add Project
---

_Creates new empty Project for current User_

### Request

~~~json
POST /v1/s-00001-almagro/projects/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Content-Type: application/json
Host: demo.local

{'name':'Some New Project','description':'Freshly created Project'}
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2017-04-23T17:56:59Z",
    "duration": 0,
    "moment": "2017-04-23T17:56:59Z",
    "name": "Some New Project",
    "id": 17,
    "description": "Freshly created Project"
}
~~~

Update Project
---

### Request

~~~json
POST /v1/s-00001-almagro/projects/17/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Content-Type: application/json
Host: demo.local

{'name':'Some Great New Project','description':'Freshly created great Project'}
~~~

### Request

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2017-04-23T17:56:59Z",
    "duration": 0,
    "moment": "2017-04-23T18:01:53Z",
    "name": "Some Great New Project",
    "id": 17,
    "description": "Freshly created great Project"
}
~~~

Delete Project
---

_Deleting Project stops all Tasks belonging to it, and de-associates Tasks from that Project._

### Request

~~~json
DELETE /v1/s-00001-almagro/projects/17/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Host: demo.local
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2017-04-23T17:56:59Z",
    "duration": 0,
    "moment": "2017-04-23T18:06:48Z",
    "name": "Some Great New Project",
    "id": 17,
    "description": "Freshly created great Project"
}
~~~
