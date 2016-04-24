local redis = require "resty.redis"

local ls = {}

function ls.route(arg1, arg2, method)
  if arg1 ~= "register" and not arg2 and method == "GET" then
    ls.ls(arg1)
    return true
  else
    return false
  end
end

function ls.init()
  local red_client, err = redis:new()
  red_client:set_timeout(1000)
  local ok, err = red_client:connect("127.0.0.1", 6379)
  if not ok then
    ngx.err(ngx.ERR, string.format("failed to connect to redis: %s", err))
    return nil
  else
    return red_client 
  end
end

function ls.ls(uid)
  local items, err, list_key
  local red_client = ls.init()
  list_key = "pages:" .. uid
  items, err = red_client:lrange(list_key, 0, -1)
  for _, item in ipairs(items) do
    ngx.say("https://textdash.xyz/" .. uid .. "/" .. item)
  end
end

return ls
