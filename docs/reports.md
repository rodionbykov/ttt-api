# Reports

Summary report
---

**Summary report per activity; time spent for each activity during period**

### Request

~~~json
GET /v1/s-00001-almagro/reports/summary/&from=2017-01-01&to=2017-03-31 HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Host: demo.local
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

[{
    "duration": 27157,
    "activity": {
        "id": 193,
        "description": "Release",
        "task": {
            "id": 115,
            "title": "Deployments"
        }
    }
}, {
    "duration": 6196,
    "activity": {
        "id": 201,
        "description": "Setup machine",
        "task": {
            "id": 118,
            "title": "Environment"
        }
    }
}, {
    "duration": 16813,
    "activity": {
        "id": 206,
        "description": "Jenkins",
        "task": {
            "id": 121,
            "title": "Integration"
        }
    }
}, {
    "duration": 2288,
    "activity": {
        "id": 90,
        "description": "Lunches",
        "task": {
            "id": 42,
            "title": "Breaks"
        }
    }
}]
~~~

Activity Report
---

**Time report summarized by day/activity; daily times spent over activity**

### Request

~~~json
GET /v1/s-00001-almagro/reports/activity/&from=2017-01-01&to=2017-03-31 HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Host: demo.local
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

[{
    "duration": 16,
    "activity": {
        "id": 192,
        "description": "Homepage design",
        "task": {
            "project": {
                "name": "Billable work",
                "id": 12
            },
            "id": 89,
            "title": "Support Tickets"
        }
    },
    "datestarted": "2017-01-17T00:00:00Z"
}, {
    "duration": 15465,
    "activity": {
        "id": 191,
        "description": "Homepage design",
        "task": {
            "project": {
                "name": "Billable work",
                "id": 12
            },
            "id": 89,
            "title": "Support Tickets"
        }
    },
    "datestarted": "2017-01-17T00:00:00Z"
}, {
    "duration": 1769,
    "activity": {
        "id": 126,
        "description": "Daily scrum",
        "task": {
            "project": {
                "name": "Billable work",
                "id": 12
            },
            "id": 75,
            "title": "Meetings"
        }
    },
    "datestarted": "2017-01-17T00:00:00Z"
}, {
    "duration": 12905,
    "activity": {
        "id": 127,
        "description": "Sorting emails",
        "task": {
            "project": {
                "name": "Billable work",
                "id": 12
            },
            "id": 77,
            "title": "Project management"
        }
    },
    "datestarted": "2017-01-17T00:00:00Z"
}, {
    "duration": 27157,
    "activity": {
        "id": 193,
        "description": "Next release",
        "task": {
            "id": 115,
            "title": "Deployments"
        }
    },
    "datestarted": "2017-01-18T00:00:00Z"
}, {
    "duration": 3599,
    "activity": {
        "id": 194,
        "description": "Docker",
        "task": {
            "project": {
                "name": "Billable work",
                "id": 12
            },
            "id": 76,
            "title": "Learning"
        }
    },
    "datestarted": "2017-01-20T00:00:00Z"
}]
~~~

Time Report
---

**Detailed time report for the period**

### Request

~~~json
GET /v1/s-00001-almagro/reports/timelog/&from=2017-01-01&to=2017-03-31 HTTP/1.1
Authorization: Bearer c276a245e07cd21bfb3c378b29f0fa9ec4c806fa
Host: demo.local
~~~

### Response

~~~json
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

[{
    "duration": 16,
    "started": "2017-01-17T08:38:14Z",
    "activity": {
        "id": 192,
        "description": "Homepage design",
        "task": {
            "project": {
                "name": "Billable work",
                "id": 12
            },
            "id": 89,
            "title": "Support Tickets"
        }
    },
    "id": 364,
    "stopped": "2017-01-17T08:38:30Z",
    "datestarted": "2017-01-17T00:00:00Z"
}, {
    "duration": 13010,
    "started": "2017-01-17T08:38:41Z",
    "activity": {
        "id": 191,
        "description": "Homepage design",
        "task": {
            "project": {
                "name": "Billable work",
                "id": 12
            },
            "id": 89,
            "title": "Support Tickets"
        }
    },
    "id": 365,
    "stopped": "2017-01-17T12:15:31Z",
    "datestarted": "2017-01-17T00:00:00Z"
}, {
    "duration": 2455,
    "started": "2017-01-17T12:45:00Z",
    "activity": {
        "id": 191,
        "description": "Homepage design",
        "task": {
            "project": {
                "name": "Billable work",
                "id": 12
            },
            "id": 89,
            "title": "Support Tickets"
        }
    },
    "id": 367,
    "stopped": "2017-01-17T13:25:55Z",
    "datestarted": "2017-01-17T00:00:00Z"
}, {
    "duration": 12905,
    "started": "2017-01-17T13:25:55Z",
    "activity": {
        "id": 127,
        "description": "Emails",
        "task": {
            "project": {
                "name": "Billable work",
                "id": 12
            },
            "id": 77,
            "title": "Project management"
        }
    },
    "id": 368,
    "stopped": "2017-01-17T17:01:00Z",
    "datestarted": "2017-01-17T00:00:00Z"
}, {
    "duration": 16521,
    "started": "2017-01-18T08:03:56Z",
    "activity": {
        "id": 193,
        "description": "Next Release",
        "task": {
            "id": 115,
            "title": "Deployments"
        }
    },
    "id": 369,
    "stopped": "2017-01-18T12:39:17Z",
    "datestarted": "2017-01-18T00:00:00Z"
}, {
    "duration": 3599,
    "started": "2017-01-20T11:21:52Z",
    "activity": {
        "id": 194,
        "description": "Docker",
        "task": {
            "project": {
                "name": "Billable work",
                "id": 12
            },
            "id": 76,
            "title": "Learning"
        }
    },
    "id": 372,
    "stopped": "2017-01-20T12:21:51Z",
    "datestarted": "2017-01-20T00:00:00Z"
}, {
    "duration": 11636,
    "started": "2017-01-24T08:25:38Z",
    "activity": {
        "id": 127,
        "description": "Sorting Emails",
        "task": {
            "project": {
                "name": "Billable work",
                "id": 12
            },
            "id": 77,
            "title": "Project management"
        }
    },
    "id": 377,
    "stopped": "2017-01-24T11:39:34Z",
    "datestarted": "2017-01-24T00:00:00Z"
}, {
    "duration": 4344,
    "started": "2017-02-09T11:26:10Z",
    "activity": {
        "id": 202,
        "description": "Create Confluence pages with documentation",
        "task": {
            "project": {
                "name": "Shipping and handling",
                "id": 16
            },
            "id": 119,
            "title": "Documentation"
        }
    },
    "id": 394,
    "stopped": "2017-02-09T12:38:34Z",
    "datestarted": "2017-02-09T00:00:00Z"
}]
~~~