### pipe mq for th 

---

### Usage

__Users__

```elixir
# send message to user process, process id stored in redis
:gen_server.call :users, { :notify, user_id, message }


# store process id by user id
:gen_server.call :users, { :subscribe, user_id, pid }


# drop process id
:gen_server.call :users, { :unsubscribe, user_id }


# get user PID by user_id, whet it not exists
# we spawn new process and return new PID
:gen_server.call :users, { :pid, 123 }


# get all user sessions by his user_id
# returns false if session doesn't exist
# or return user_id when it exist
:gen_server.call :users, { :session, "session_id" }


# get all user sessions by his user_id
# returns empty array ([]) when user hasn't
# any sessions, or return his sessions array
:gen_server.call :users, { :sessions, 123 }


# get user online state by user_id
# returns only false or true
:gen_server.call :users, { :online, 123 }


# set user online state by user_id
:gen_server.call :users, { :online, 123, state }
```

__WebSockets__

`http://0.0.0.0:8080`

By default it attaching to `http://0.0.0.0:8080` and anyone allow to get this page.

__Internal API__

`http://127.0.0.1:8080`

By default API server attaching to `http://127.0.0.1:8080` and only local machines can use it.

```http
GET /

  Hello World!

GET /version

  0.1-beta

```
