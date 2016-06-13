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
  local ok, err, red_client, org_available, password

  red_client = register.init()
  
  if not org then
    org = resty_string.to_hex(random.bytes(6))
  end
  password = resty_string.to_hex(random.bytes(20))
  org_available, err = red_client:setnx ("register:" .. org, emailaddr)
  if org_available == 1 then
    ok, err = red_client:set ("uid:" .. key, emailaddr)
    ok, err = red_client:set ("password:" .. key, password)
  else
    return register.error_user_exists()
  end
  local blurb = string.format(
[[Account created named '%s', API key is '%s'

View log dashboards with: curl -H "key: %s" http://textdash.xyz/%s]], org, password, password)
  red_client:rpush("emailqueue", string.format("%s\n%s", emailaddr, blurb))
  ngx.say(blurb)

end

return register
