Authentification 
===

There are three key methods for auntenticate a user

* Login
* Ping
* Logout

Ping
---

### Request

~~~json
GET /v1/s-00001-almagro/users/ping/ HTTP/1.1
Host: demo.local
Authorization: Bearer ae616d74c318c2b552d8a22f00b2f1b2b85783d5
Origin: https://demo.local
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8
Content-Length: 397

{
    "activity": {
        "created": "2016-10-03T06:58:14Z",
        "duration": 122869,
        "moment": "2017-04-10T07:40:53Z",
        "started": "2016-10-03T06:58:14Z",
        "id": 118,
        "stopped": "",
        "isrunning": 1,
        "description": "Coffee",
        "task": {
            "project": {
                "name": "Work",
                "id": 12
            },
            "id": 75,
            "title": "Breaks and lunches"
        }
    },
    "user": {
        "lastname": "John",
        "firstname": "Smith",
        "id": 4,
        "login": "user@demo",
        "email": "user@demo"
    }
}
~~~

Login
---

Login and password should be sent as for Basic Authentification: it should be Base64 encoded string "login:password". In this string password should be signed using HMAC SHA1 function, using as key Subscriber's secret.

### Request

~~~json
POST /v1/s-00001-almagro/users/login/ HTTP/1.1
Host: demo.local
Authorization: Basic YZRtaA46MjBEZzBENTGFRjk1MjhBM0HCQkI5OTJEQzIzNzI5DTRGQTkzFEMyMg==
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8
Content-Length: 243
{
   "moment":"2016-04-23T10:43:08Z",
   "tokens":[
      "UserLoggedIn"
   ],
   "created":"2016-04-23T10:43:08Z",
   "lastname":"User",
   "sessiontoken":"3c93a2dded174de61f873eb2088a8b0fb6f6f319",
   "activity":{
      "duration":5767,
      "moment":"2016-04-23T10:41:49Z",
      "started":"2016-02-28T21:18:02Z",
      "id":80,
      "stopped":"",
      "isrunning":1,
      "description":"Some currently running activity",
      "task":{
         "id":42,
         "title":"Running this activity right now"
      }
   },
   "firstname":"Some",
   "id":4,
   "login":"user",
   "email":"user@demo"
}
~~~
