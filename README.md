### pipe mq for th 

---

### Usage

__Users__

```elixir
# get user PID by user_id, whet it not exists
# we spawn new process and return new PID
:gen_server.call :users, {:pid, 123}


# get all user sessions by his user_id
# returns false if session doesn't exist
# or return user_id when it exist
:gen_server.call :users, {:session, "session_id"}


# get all user sessions by his user_id
# returns empty array ([]) when user hasn't
# any sessions, or return his sessions array
:gen_server.call :users, {:sessions, 123}


# get user online state by user_id
# returns only false or true
:gen_server.call :users, {:online, 123}


# set user online state by user_id
:gen_server.call :users, {:online, 123, state}
```
