local record = require("users.record")

local write = {}

function write.route(redis, arg1, arg2, method)

  -- arg1 is orgname
  -- arg2 is dashboard
  local headers = ngx.req.get_headers()
  local request_password = headers['key']
  if arg1 and arg2 and (method == "POST" or method == "PUT") then
    if method == "PUT" then
      if not record.clear(redis, arg1, arg2, request_password) then
        return false
      end
    end
    ngx.req.read_body()
    local body_data = ngx.req.get_body_data()
    if type(body_data) == "string" and string.len(body_data) > 0 then
      for ln in body_data:gmatch("[^\r\n]+") do
        if not record.log(redis, arg1, arg2, request_password, ln) then
          return false
        end
      end
    end
    return true
  else
    return false
  end
end

return write
