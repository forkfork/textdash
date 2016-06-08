local user = require("users.user")

local read = {}

function read.route(redis, arg1, arg2, method)
  if arg1 ~= "register" and arg2 and method == "GET" then
    read.read(redis, arg1, arg2)
    return true
  else
    return false
  end
end

function read.read(redis, uid, did)
  local ok
  local client_status = "OK"
  local headers = ngx.req.get_headers()
  local stream = headers['accept'] == 'text/event-stream'
  local request_password = headers['key']
  if not user.auth(redis, uid, did, request_password) then
    return false
  end
  if stream then
    local on_abort = function()
      ngx.log(ngx.ERR, "ABORTED")
      redis:set_keepalive(30000, 100)
      client_status = "ABORT"
      ngx.exit(499)
    end
    ngx.on_abort(on_abort)
    ngx.header["Content-Type"] = "text/event-stream"
    ngx.send_headers()
  end
  local items, err, list_key, res
  list_key = "log:" .. uid .. ":" .. did
  items, err = redis:lrange(list_key, -30, -1)
  for _, item in ipairs(items) do
    ngx.say(item)
  end
  if stream then
    ngx.flush()
    redis:subscribe(list_key)
    while not err and client_status == "OK" do
      res, err = redis:read_reply()
      if res then
        ngx.say(res[3])
        ngx.flush()
      else
        if err == "timeout" then
          log("TIMEOUT")
          ok, err = redis:connect("127.0.0.1", 6379)
          redis:subscribe(list_key)
          break
        else
          log("OTHER ERROR")
          log(err)
          break
        end
      end
    end
  end
  redis:set_keepalive(30000, 100)
end

return read
