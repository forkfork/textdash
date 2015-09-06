local redis = require "resty.redis"

local write = {}

function write.route(arg1, arg2, method)
  if arg1 and arg2 and method == "POST" then
    ngx.req.read_body()
    local body_data = ngx.req.get_body_data()
    write.write(arg1, arg2, body_data)
    return true
  else
    return false
  end
end

function write.init()
  local ok, err, red_client
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

function write.write(uid, did, data)
  local ok, len, err, list_key
  local red_client = write.init()
  list_key = "log:" .. uid .. ":" .. did
  len, err = red_client:rpush(list_key, data)
  red_client:publish(list_key, data)
  if len == 1 then
    ok, err = red_client:rpush("pages:" .. uid, did)
  end
  len, err = red_client:llen(list_key)
  if len > 100 then
    ok, err = red_client:lpop(list_key)
  end
end

return write
