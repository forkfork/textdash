local redis = require "resty.redis"

local read = {}

function read.route(arg1, arg2, method)
  if arg1 ~= "register" and arg2 and method == "GET" then
    read.read(arg1, arg2)
    return true
  else
    return false
  end
end

function read.init()
  local ok, err
  local red_client
  red_client, err = redis:new()
  red_client:set_timeout(1000 * 5)
  ok, err = red_client:connect("127.0.0.1", 6379)
  if not ok then
    ngx.err(ngx.ERR, string.format("failed to connect to redis: %s", err))
    return nil
  else
    return red_client 
  end
end

function read.read(uid, did)
  local ok
  local client_status = "OK"
  local red_client = read.init()
  local headers = ngx.req.get_headers()
  local stream = headers['accept'] == 'text/event-stream'
  if stream then
    local on_abort = function()
      ngx.log(ngx.ERR, "ABORTED")
      red_client:set_keepalive(30000, 100)
      client_status = "ABORT"
      ngx.exit(499)
    end
    ngx.on_abort(on_abort)
    ngx.header["Content-Type"] = "text/event-stream"
    ngx.send_headers()
  end
  local items, err, list_key, res
  list_key = "log:" .. uid .. ":" .. did
  items, err = red_client:lrange(list_key, -30, -1)
  for _, item in ipairs(items) do
    ngx.say(item)
  end
  if stream then
    ngx.flush()
    red_client:subscribe(list_key)
    while not err and client_status == "OK" do
      res, err = red_client:read_reply()
      if res then
        ngx.say(res[3])
        ngx.flush()
      else
        if err == "timeout" then
          log("TIMEOUT")
          --ok, err = red_client:connect("127.0.0.1", 6379)
          --red_client:subscribe(list_key)
          break
        else
          log("OTHER ERROR")
          log(err)
          break
        end
      end
    end
  end
  red_client:set_keepalive(30000, 100)
end

return read
