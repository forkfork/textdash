local user = require("users.user")

local record = {}

record.log = function(redis, orgname, dashboard, ln)

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


local tests = [[
local restyredis = require("resty.redis")
redis = restyredis.new()
redis:connect("127.0.0.1", 6379)

record.log(redis, "foo", "aaa", "log line 1")
]]

return record
