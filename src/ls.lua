local user = require("users.user")

local ls = {}

function ls.route(redis, orgname, arg2, method)
  -- arg1 is orgname
  -- arg2 is empty
  -- method is GET

  if orgname ~= "register" and not arg2 and method == "GET" then

    -- check auth
    local headers = ngx.req.get_headers()
    local request_password = headers['key']
    if not user.auth(redis, orgname, nil, request_password) then
      return false
    end

    local items = user.ls(redis, orgname)
    if items then
      for i = 1, #items do
        ngx.say("https://textdash.xyz/" .. orgname .. "/" .. items[i])
      end
    end
    return true
  else
    return false
  end
end

return ls
