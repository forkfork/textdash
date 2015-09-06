local redis = require "resty.redis"
local random = require 'resty.random'
local resty_string = require 'resty.string'

local register = {}


function register.route(arg1, arg2, method)
  if arg1 == "register" then
    register.create(arg2)
    return true
  else
    return false
  end
end

register.error_args = function()
  ngx.say[[Args: /register/me@example.com]]
end

register.error_user_exists = function()
  ngx.say[[that email address is unavailable]]
end

function register.init()
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

function register._create(emailaddr)
  local red_client = register.init()
  local ok
  local random_hex = resty_string.to_hex(random.bytes(6))
  local email_available, err = red_client:setnx ("register:" .. emailaddr, random_hex)
  if email_available == 1 then
    ok, err = red_client:set ("uid:" .. random_hex, emailaddr)
  end
  
  return email_available == 1, random_hex, err
end

register.create = function(emailaddr)
  local success, key, err = register._create(emailaddr)
  if not success then
    return register.error_user_exists()
  end
  ngx.say(string.format(
[[Done! Your key is: %s

We've also emailed you that key. Circulate as needed.

Next step: start writing logs to a dashboard:

curl -X POST -d "Server load: 50%%" https://textdash.xyz/%s/myamazingapp

This will write to a dashboard 'myamazingapp' creating if needed. You can view at: https://textdash.xyz/%s/myamazingapp

View all your log dashboards at https://textdash.xyz/%s]], key, key, key, key))

end

return register
