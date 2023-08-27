Subscriber: a billing agent	
===

* Owns the account (login)
* Can create unlimited number of Users
* Can purchase packages of Passes which serve as payment for using API
* All Users activity with API is counted against Subscriber's account balance


Redeem Package
---

Method adds Package nominal value of 'passes' to Subscriber's account. Used to replenish Subscriber's account. This method only can be called if User has AdminLoggedIn security token.

### Request

~~~json
POST /v1/s-00001-almagro/users/redeem/ HTTP/1.1
Host: demo.local
Authorization: Bearer f54218daf5e48c4d6e7db5bd5a50db5239bc16fc
Content-Type: application/json

{'package': '40CD8962-BA32-419C-AFFA-790E03FD8501'}
~~~

### Response

~~~json
HTTP/1.1 200 200
Access-Control-Allow-Origin: https://demo.local
Content-Type: application/json;charset=utf-8

{
    "credits": 1000000,
    "name": "Demo",
    "id": 1
}
~~~
