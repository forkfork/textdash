local record = require("users.record")

local write = {}

function write.route(redis, arg1, arg2, method)

  -- arg1 is orgname
  -- arg2 is dashboard
  if arg1 and arg2 and method == "POST" then
    ngx.req.read_body()
    local body_data = ngx.req.get_body_data()
    if type(body_data) == "string" and string.len(body_data) > 0 then
      for ln in body_data:gmatch("[^\r\n]+") do
        record.log(redis, arg1, arg2, ln)
      end
    end
    return true
  else
    return false
  end
end

return write
