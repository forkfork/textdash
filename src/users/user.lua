local restystring = require"resty.string"
local random = require"resty.random"

local user = {}

user.register = function(redis, email, orgname)
  local accttype = orgname and "named" or "lite"
  
  if not orgname then
    orgname = restystring.to_hex(random.bytes(12))
  end

  if redis:setnx("uid:" .. orgname, email) == 0 then
    -- username already taken
    ngx.say("orgname aready taken")
    return nil, nil, "dup"
  end

  local password = restystring.to_hex(random.bytes(20))

  redis:mset("pwd:" .. orgname, password,
             "accttype:" .. orgname, accttype)
  
  return orgname, email, password, nil
end

user.ratelimit = function(redis, orgname)
  local hits, err = redis:get("ratelimit:" .. orgname)
  if hits ~= ngx.null and tonumber(hits) > 10000 then
    return true
  end
  if hits == ngx.null then
    redis:set("ratelimit:" .. orgname, 1, "ex", 60)
  end
  return false
end

user.auth = function(redis, orgname, dashboard, password)
  local real_password, err = redis:get("pwd:" .. orgname)
  if real_password ~= password then
    ngx.say("incorrect password")
    return false
  end
  return true
end

function user.ls(redis, orgname)
  local items, err, list_key
  items, err = redis:lrange("pages:" .. orgname, 0, -1)
  return items
end

user.registration_email = function(redis, orgname, email, password)
  
  local blurb = string.format(
[[Your account name is: %s

Your random security key of: %s


Example 1 - write a log line to a dashboard:
curl -X POST -d "Server load: 50%%" https://textdash.xyz/%s/myamazingapp
This will write to a dashboard 'myamazingapp' creating if needed. 

Example 2 - read a dashboard:
curl -H "key: %s" http://textdash.xyz/%s/myamazingapp

Example 3 - list your dashboards:
curl -H "key: %s" http://textdash.xyz/%s

Example 4 - stream logs from an app to your dashboard (line buffered)
{ echo "%s myamazingapp" ; tail -F myamazingapp.log ; } | nc textdash.xyz 5052

Example 5 - read a stream of logs from your dashboard:
curl -H "key: %s" -H "accept: text/event-stream" http://textdash.xyz/%s/myamazingapp]],
  orgname, password, orgname, password, orgname, password, orgname, orgname, password, orgname)

  redis:rpush("emailqueue", string.format("%s\n%s", email, blurb))

end

local tests = [[
local restyredis = require("resty.redis")
redis = restyredis.new()
redis:connect("127.0.0.1", 6379)

user.register(redis, "foo@aaa.com", "testorg")
local pwd = redis:get("pwd:testorg")
print(user.auth(redis, "testorg", "testdash", pwd))
user.registration_email(redis, "testorg", "timothydowns+test@gmail.com", "passwd")
]]

return user
