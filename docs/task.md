Task: a bunch of Activities	
===

**Grouping element for Activities**

_Task groups together several Activities, summarizes time spent on its Activities. Task may or may not belong to Project._

* Can group together several activities
* Summarizes time spent on its Activities
* Can belong to Projects or not

## Get Task

### Request

~~~json
GET /v1/s-00001-almagro/tasks/91/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Host: demo.local
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2016-10-05T09:05:34Z",
    "duration": 7597,
    "moment": "2016-10-05T11:14:00Z",
    "activities": [{
        "created": "2016-10-05T09:05:34Z",
        "duration": 7597,
        "moment": "2016-10-05T11:14:00Z",
        "started": "2016-10-05T09:05:34Z",
        "id": 137,
        "stopped": "2016-10-05T11:14:00Z",
        "isrunning": 0,
        "description": "Skype with team",
        "task": {
            "id": 91,
            "title": "Meeting"
        }
    }],
    "id": 91,
    "isrunning": 0,
    "title": "Meeting",
    "description": "Team meeting"
}
~~~

## Get Tasks

### Request

~~~json
GET /v1/s-00001-almagro/tasks/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Host: demo.local
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

[{
    "created": "2013-12-23T22:23:08Z",
    "duration": 2767,
    "moment": "2017-04-08T09:09:35Z",
    "activities": [{
        "created": "2017-03-29T20:36:29Z",
        "duration": 2767,
        "moment": "2017-04-08T09:09:35Z",
        "started": "2017-03-29T20:36:29Z",
        "id": 212,
        "stopped": "",
        "isrunning": 1,
        "description": "New activity with a task",
        "task": {
            "project": {
                "name": "New project",
                "id": 4
            },
            "id": 12,
            "title": "New task"
        }
    }],
    "project": {
        "name": "Created new project",
        "id": 4
    },
    "id": 12,
    "isrunning": 1,
    "title": "New task",
    "description": "Description for new task"
},
{
    "created": "2016-10-03T06:56:18Z",
    "duration": 208831,
    "moment": "2017-03-22T11:56:00Z",
    "activities": [{
        "created": "2016-10-03T10:50:34Z",
        "duration": 49911,
        "moment": "2017-03-22T11:56:00Z",
        "started": "2016-10-03T10:50:34Z",
        "id": 126,
        "stopped": "2017-03-22T11:56:00Z",
        "isrunning": 0,
        "description": "Lunch",
        "task": {
            "project": {
                "name": "Free time",
                "id": 12
            },
            "id": 75,
            "title": "Breaks and lunches"
        }
    }],
    "id": 42,
    "isrunning": 0,
    "title": "Breaks and lunches",
    "description": "Free time for munchies"

}]
~~~

## Add Task

> Without Project reference

### Request

~~~json
POST /v1/s-00001-almagro/tasks/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Content-Type: application/json
Host: demo.local

{ 
    "title":"Some Title for New Task","description":"Some Description for New Task"
}
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2017-04-12T19:36:03Z",
    "duration": 0,
    "moment": "2017-04-12T19:36:03Z",
    "id": 123,
    "isrunning": 0,
    "title": "Some Title for New Task",
    "description": "Some Description for New Task"
}
~~~

> With Project reference

### Request

~~~json
POST /v1/s-00001-almagro/tasks/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Content-Type: application/json
Host: demo.local

{'projectid':8,'title':'Some Title for New Task','description':'Some Description for New Task'}
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2017-04-12T19:41:25Z",
    "duration": 0,
    "moment": "2017-04-12T19:41:25Z",
    "project": {
        "name": "Lorem Ipsum",
        "id": 8
    },
    "id": 124,
    "isrunning": 0,
    "title": "Some Title for New Task",
    "description": "Some Description for New Task"
}
~~~

## Update Task

> With Project reference

### Request

~~~json
POST /v1/s-00001-almagro/tasks/112/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Content-Type: application/json
Host: demo.local

{'projectid':8,'title':'Updated task title','description':'Updated task description'}
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
  "created": "2016-10-18T07:18:39Z",
  "duration": 34255,
  "moment": "2017-04-22T16:28:17Z",
  "activities": [
    {
      "created": "2017-02-15T10:56:20Z",
      "duration": 5800,
      "moment": "2017-02-15T12:33:00Z",
      "started": "2017-02-15T10:56:20Z",
      "id": 204,
      "stopped": "2017-02-15T12:33:00Z",
      "isrunning": 0,
      "description": "Deploy and testing",
      "task": {
        "project": {
          "name": "Lorem Ipsum",
          "id": 8
        },
        "id": 112,
        "title": "Updated task title"
      }
    },
    {
      "created": "2016-10-18T07:19:23Z",
      "duration": 28455,
      "moment": "2016-12-14T10:20:13Z",
      "started": "2016-10-18T07:19:31Z",
      "id": 173,
      "stopped": "2016-12-14T10:20:13Z",
      "isrunning": 0,
      "description": "Packaging",
      "task": {
        "project": {
          "name": "Lorem Ipsum",
          "id": 8
        },
        "id": 112,
        "title": "Updated task title"
      }
    }
  ],
  "project": {
    "name": "Lorem Ipsum",
    "id": 8
  },
  "id": 112,
  "isrunning": 0,
  "title": "Updated task title",
  "description": "Updated task description"
}
~~~

> Without Project reference

### Request

~~~json
POST /v1/s-00001-almagro/tasks/112/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Content-Type: application/json
Host: demo.local

{'title':'Updated task title','description':'Updated task description'}
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2016-10-18T07:18:39Z",
    "duration": 34255,
    "moment": "2017-04-22T17:00:58Z",
    "activities": [{
        "created": "2017-02-15T10:56:20Z",
        "duration": 5800,
        "moment": "2017-02-15T12:33:00Z",
        "started": "2017-02-15T10:56:20Z",
        "id": 204,
        "stopped": "2017-02-15T12:33:00Z",
        "isrunning": 0,
        "description": "Deploy and testing",
        "task": {
            "id": 112,
            "title": "Updated task title"
        }
    }, {
        "created": "2016-10-18T07:19:23Z",
        "duration": 28455,
        "moment": "2016-12-14T10:20:13Z",
        "started": "2016-10-18T07:19:31Z",
        "id": 173,
        "stopped": "2016-12-14T10:20:13Z",
        "isrunning": 0,
        "description": "Packaging",
        "task": {
            "id": 112,
            "title": "Updated task title"
        }
    }],
    "id": 112,
    "isrunning": 0,
    "title": "Updated task title",
    "description": "Updated task description"
}
~~~

## Delete Task

_When deleting task, it become no more available to user. If Task had any Activities, all of them will be also deleted and excluded from reports._

### Request

~~~json
DELETE /v1/s-00001-almagro/tasks/94/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Host: demo.local
~~~

### Response

> Task had Activities

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
  "created": "2016-10-06T08:55:57Z",
  "duration": 0,
  "moment": "2017-04-22T17:34:04Z",
  "activities": [
    {
      "created": "",
      "duration": 0,
      "moment": "2015-09-16T09:57:28Z",
      "started": "2013-05-01T12:00:00Z",
      "id": 33,
      "stopped": "2015-09-16T09:57:28Z",
      "isrunning": 0,
      "description": "blabla",
      "task": {
        "id": 94,
        "title": "Deleted task"
      }
    }
  ],
  "id": 94,
  "isrunning": 0,
  "title": "Deleted task",
  "description": ""
}
~~~

> Task had no Activities

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2016-10-06T08:55:57Z",
    "duration": 0,
    "moment": "2017-04-22T17:16:19Z",
    "id": 94,
    "isrunning": 0,
    "title": "Deleted task",
    "description": ""
}
~~~

## Quickstart Task

_Creates Task and Activity, starts Activity immediately (any others running Activities stop). Returns Activity._

> Without Project reference

### Request

~~~json
PUT /v1/s-00001-almagro/tasks/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Content-Type: application/json
Host: demo.local

{'title':'Quickstarted Task','description':'Quickstarted Activity'}
~~~

### Response

HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2017-04-22T17:43:08Z",
    "duration": 0,
    "moment": "2017-04-22T17:43:08Z",
    "started": "2017-04-22T17:43:08Z",
    "id": 215,
    "stopped": "",
    "isrunning": 1,
    "description": "Quickstarted Activity",
    "task": {
        "id": 125,
        "title": "Quickstarted Task"
    }
}

> With Project reference

###Request

~~~json
PUT /v1/s-00001-almagro/projects/15/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Content-Type: application/json
Host: demo.local

{'title':'Quickstarted Project Task','description':'Quickstarted Project Task Activity'}
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2017-04-22T17:49:27Z",
    "duration": 0,
    "moment": "2017-04-22T17:49:27Z",
    "started": "2017-04-22T17:49:27Z",
    "id": 216,
    "stopped": "",
    "isrunning": 1,
    "description": "Quickstarted Project Task Activity",
    "task": {
        "project": {
            "name": "Some existing project",
            "id": 15
        },
        "id": 126,
        "title": "Quickstarted Project Task"
    }
}
~~~

## Stop Task

_Automatically stops all activities on given task. User can stop only own tasks._

### Request

~~~json
PATCH /v1/s-00001-almagro/tasks/126/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Host: demo.local
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
  "created": "2017-04-22T17:49:27Z",
  "duration": 7861,
  "moment": "2017-04-23T16:25:15Z",
  "project": {
    "id": 15,
    "name": "Some existing project"
  },
  "id": 126,
  "title": "Quickstarted Project Task",
  "isrunning": 0,
  "description": ""
}
~~~
