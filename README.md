# ttt-api
Task/Time Tracker JSON REST API

## Time tracking as a service
 * Measure time spent by starting and stopping Activities
 * Create Tasks
 * Create Activities in Tasks
 * Group Tasks into Projects
 * Create detailed and summary Reports
 * Create your own task/time tracking application
 * Integrate time tracking capabilities into your existing software

 ## Subscriber model
 * Subscriber can create unlimited number of users
 * Users 'pay' for service per API call, debiting Subscriber's credit

## F.A.Q.

### What is it?
It is a task/time tracking JSON API. It is developed with Lucee and MySQL. You can run it on Lucee or Adobe Coldfusion application server.

### What objects and functions are available?
Main three objects are Activity, Task and Project.

 * Activity is a main time tracking object. Activities may be linked to Tasks
 * Tasks can be grouped to Projects
 * All three objects have CRUD operaions, i.e. can be listed, created, edited and deleted
 * Activity can be started and stopped
 * API tracks summary time per Activity

### Who are Subscribers?
Subsciber is a company or an individual who has administrative access to API and maintains credit. Subscriber can create unlimited number of Users.

### How service is paid?
Every User interaction with the API is called a 'pass'. Logging in, reading list of Tasks, starting or stopping Activity is a 'pass'. Subscribers can redeem packages to get 'passes', which are stored with Subscriber's account. Every pass debited by User calling the API is deducted from Subscriber's account. Once passes count falls below 0, Subscriber and Users registered by Subscriber will not be allowed to do API requests.

 ### What's a Pass?
Pass is a payment unit. Each interaction with API costs User 1 Pass. Subscriber's account is debited for all User's interactions with the API.
                      
### Who's a User?
End-User of the API. Actually uses the API. Creates Activities, Tasks, Projects. Created and granted access to API by the Subscriber.

### What are building blocks of API?

 * Tidbit: Ti(me) Bit, smallest time interval, user starts and stops tidbits
 * Activity: the track of work User does, can have many Tidbits, as Activity can be started and stopped
 * Task: bunch of Activities
 * Project: bunch of Tasks or Activities
