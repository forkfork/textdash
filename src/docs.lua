local landing = require("landing")

local docs = {}

function docs.route(redis, arg1, arg2, method)
  if not arg1 or (arg1 == "") or (arg1 == "docs") then
    ngx.say(landing)
    return true
  else
    return false
  end
end

return docs
