local redis = require "resty.redis"
local record = require "users.record"

local tcpserver = {}

-- redis stuff

function tcpserver.init()
  local ok, err, red_client
  red_client, err = redis:new()
  red_client:set_timeout(1000 * 60 * 60 * 24)
  ok, err = red_client:connect("127.0.0.1", 6379)
  if not ok then
    ngx.log(ngx.ERR, string.format("failed to connect to redis: %s", err))
    return nil
  else
    return red_client
  end
end


-- TCP connection handler

function tcpserver.connection()
  local sock = assert(ngx.req.socket(true))
  sock:settimeout(1000 * 60 * 60 * 24)
  local header = sock:receive()
  local uid, did, pwd = string.match(header, "(%g*) (%g*) (%g*)")
  if not uid or not did then
    ngx.eof()
    return
  end
  local list_key = "log:" .. uid .. ":" .. did
  
  local red_client = tcpserver.init()

  local ln = sock:receive()
  while ln do
    record.log(red_client, uid, did, pwd, ln)
    ln = sock:receive()
  end
end

return tcpserver
