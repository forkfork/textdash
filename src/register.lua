local user = require("users.user")

local register = {}


function register.route(redis, arg1, arg2, method)
  if arg1 == "register" then
    arg2 = string.match(arg2,'^[%w+%.%-_]+@[%w+%.%-_]+%.%a%a+$')
    if not arg2 then
      ngx.say("invalid email address")
      return true
    end
    local headers = ngx.req.get_headers()

    user.register(redis, arg2, headers.org)

    return true
  else
    return false
  end
end

register.error_args = function()
  ngx.say[[Args: /register/me@example.com]]
end

register.error_user_exists = function()
  ngx.say[[that org name is unavailable]]
end

register.create = function(emailaddr, org)
  local ok, err, red_client, key, org_available, password, password_blurb
  local headers = ngx.req.get_headers()

  red_client = register.init()
  if headers.org then
    key = tostring(headers.org)
    password = resty_string.to_hex(random.bytes(20))
  else
    key = resty_string.to_hex(random.bytes(6))
  end
  if headers.org then
    org_available, err = red_client:setnx ("register:" .. org, emailaddr)
    if org_available == 1 then
      ok, err = red_client:set ("uid:" .. key, emailaddr)
      ok, err = red_client:set ("password:" .. key, password)
    else
      return register.error_user_exists()
    end
    password_blurb = ""
  else
    ok, err = red_client:set ("uid:" .. key, emailaddr)
    password_blurb = ""
  end
  
  red_client:rpush("emailqueue", string.format("%s %s", key, emailaddr))
  ngx.say(string.format(
[[Done! Your organisation name is: %s

We've also emailed you that name. Circulate as needed.

Next step: start writing logs to a dashboard:

curl -4 -X POST -d "Server load: 50%%" https://textdash.xyz/%s/myamazingapp

This will write to a dashboard 'myamazingapp' creating if needed. You can view at: https://textdash.xyz/%s/myamazingapp

View all your log dashboards at https://textdash.xyz/%s

%s]], key, key, key, key, password_blurb))

end

return register
