# Activity: a piece of work

**A. is a main time tracking unit**

 * Consists of simple name and time spent
 * May be started and stopped as many times as needed 
 * Time on Activity will be summarized across all start-stop intervals, called Tidbits

## Get Activity

### Request

```json
GET /v1/s-00001-almagro/activities/16/ HTTP/1.1
Authorization: Bearer bcd6dc37a9d145de9d3bfbc719eb14cb5ff8099e
Host: demo.local
```

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
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
}
~~~


## Get Activities

### Request

~~~json
GET /v1/s-00001-almagro/activities/ HTTP/1.1
Authorization: Bearer bcd6dc37a9d145de9d3bfbc719eb14cb5ff8099e
Host: demo.local
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

[{
    "created": "",
    "duration": 0,
    "moment": "2015-09-16T09:57:28Z",
    "started": "2013-05-01T12:00:00Z",
    "id": 27,
    "stopped": "2015-09-16T09:57:28Z",
    "isrunning": 0,
    "description": "dinner",
    "task": {
        "project": {
            "name": "Created new project",
            "id": 4
        },
        "id": 14,
        "title": "asdasd"
    }
}, {
    "created": "",
    "duration": 49546698,
    "moment": "2015-09-16T09:57:28Z",
    "started": "2014-02-19T22:59:10Z",
    "id": 45,
    "stopped": "2015-09-16T09:57:28Z",
    "isrunning": 0,
    "description": "",
    "task": {
        "id": 31,
        "title": "Some Title"
    }
}]
~~~

## Add Activity

> With linked Task


### Request

~~~json
POST /v1/s-00001-almagro/activities/ HTTP/1.1
Authorization: Bearer bcd6dc37a9d145de9d3bfbc719eb14cb5ff8099e
Content-Type: application/json
Host: demo.local

{
    "taskid": "15",
    "description": "Creating new activity for task"
}
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2017-02-26T16:43:03Z",
    "duration": 0,
    "moment": "2017-02-26T16:43:03Z",
    "started": "",
    "id": 208,
    "stopped": "",
    "isrunning": 0,
    "description": "Creating new activity for task",
    "task": {
        "project": {
            "name": "Project Phi",
            "id": 5
        },
        "id": 15,
        "title": "tv"
    }
}
~~~

> Without linked Task

### Request

~~~json
POST /v1/s-00001-almagro/activities/ HTTP/1.1
Authorization: Bearer bcd6dc37a9d145de9d3bfbc719eb14cb5ff8099e
Content-Type: application/json
Host: demo.local

{
    "description": "Creating new activity without a task"
}
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2017-02-26T16:46:26Z",
    "duration": 0,
    "moment": "2017-02-26T16:46:26Z",
    "started": "",
    "id": 209,
    "stopped": "",
    "isrunning": 0,
    "description": "Creating new activity without a task"
}
~~~

## Update Activity

> Without Task assignation
 
### Request

~~~json
POST /v1/s-00001-almagro/activities/90/ HTTP/1.1
Authorization: Bearer bcd6dc37a9d145de9d3bfbc719eb14cb5ff8099e
Content-Type: application/json
Host: demo.local

{"description":"Updated description"}
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "",
    "duration": 3822,
    "moment": "2017-02-26T17:01:02Z",
    "started": "2016-03-19T21:08:38Z",
    "id": 90,
    "stopped": "2016-03-21T21:05:42Z",
    "isrunning": 0,
    "description": "Updated description"
}
~~~

> With Task assignation

### Request

~~~json
POST /v1/s-00001-almagro/activities/90/ HTTP/1.1
Authorization: Bearer bcd6dc37a9d145de9d3bfbc719eb14cb5ff8099e
Content-Type: application/json
Host: demo.local

{"taskid": 42, "description":"Updated description"}
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "",
    "duration": 3822,
    "moment": "2017-02-26T17:03:48Z",
    "started": "2016-03-19T21:08:38Z",
    "id": 90,
    "stopped": "2016-03-21T21:05:42Z",
    "isrunning": 0,
    "description": "Updated description",
    "task": {
        "id": 42,
        "title": "Job to be done"
    }
}
~~~

## Delete Activity

### Request

~~~json
DELETE /v1/s-00001-almagro/activities/31/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Content-Type: application/json
Host: demo.local
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2015-05-01T12:00:00Z",
    "duration": 0,
    "moment": "2015-09-16T09:57:28Z",
    "started": "2015-05-01T12:00:00Z",
    "id": 31,
    "stopped": "2015-09-16T09:57:28Z",
    "isrunning": 0,
    "description": "deleted activity"
}
~~~

## Quickstart Activity

### Request

~~~json
PUT /v1/s-00001-almagro/activities/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Content-Type: application/json
Host: demo.local

{
    "description": "Quickly starting new activity without a task"
}
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2017-03-29T20:17:36Z",
    "duration": 0,
    "moment": "2017-03-29T20:17:36Z",
    "started": "2017-03-29T20:17:36Z",
    "id": 210,
    "stopped": "",
    "isrunning": 1,
    "description": "Quickly starting new activity without a task"
}
~~~

## Quickstart Activity for Task

### Request

~~~json
PUT /v1/s-00001-almagro/tasks/12/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Content-Type: application/json
Host: demo.local

{
    "description": "Creating new activity with a task"
}
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{

    "created": "2017-03-29T20:36:29Z",
    "duration": 0,
    "moment": "2017-03-29T20:36:29Z",
    "started": "2017-03-29T20:36:29Z",
    "id": 212,
    "stopped": "",
    "isrunning": 1,
    "description": "Creating new activity with a task",
    "task": {
        "project": {
            "name": "new project",
            "id": 4
        },
        "id": 12,
        "title": "new task"
    }
}
~~~

## Toggle Activity

*Starts and Stops Activity. IsRunning flag is toggled. Tidbit is created.*

### Request

~~~json
PATCH /v1/s-00001-almagro/activities/212/ HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Content-Type: application/json
Host: demo.local
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "created": "2017-03-29T20:36:29Z",
    "duration": 234,
    "moment": "2017-03-29T20:40:23Z",
    "started": "2017-03-29T20:36:29Z",
    "id": 212,
    "stopped": "2017-03-29T20:40:23Z",
    "isrunning": 0,
    "description": "new activity with a task",
    "task": {
        "project": {
            "name": "new project",
            "id": 4
        },
        "id": 12,
        "title": "new task with project"
    }
}
~~~