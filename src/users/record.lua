local user = require("users.user")

local record = {}

record.log = function(redis, orgname, dashboard, password, ln)

  if not user.auth(redis, orgname, dashboard, password) then
    return nil, nil, "auth failure"
  end
  user.ratelimit(redis, orgname)

  local len, err = redis:rpush("log:" .. orgname .. ":" .. dashboard, ln)
  redis:publish("log:" .. orgname .. ":" .. dashboard, ln)
  if len == 1 then
    redis:rpush("pages:" .. orgname, dashboard)
  end
  if len > 100 then
    redis:lpop("log:" .. orgname .. ":" .. dashboard, ln)
  end
  
  return orgname, email, nil
end

record.clear = function(redis, orgname, dashboard, password)
  if not user.auth(redis, orgname, dashboard, password) then
    return false
  end
  
  redis:del("log:".. orgname .. ":" .. dashboard)
  return true
end

local tests = [[
local restyredis = require("resty.redis")
redis = restyredis.new()
redis:connect("127.0.0.1", 6379)

record.log(redis, "foo", "aaa", "log line 1")
]]

return record
