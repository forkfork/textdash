local redis = require "resty.redis"

local tcpserver = {}

-- redis stuff

function tcpserver.init()
  local ok, err, red_client
  red_client, err = redis:new()
  red_client:set_timeout(1000 * 5)
  ok, err = red_client:connect("127.0.0.1", 6379)
  if not ok then
    ngx.log(ngx.ERR, string.format("failed to connect to redis: %s", err))
    return nil
  else
    return red_client
  end
end

local addlog = function(red_client, uid, did, data)
  local ok, len, err
  local list_key = "log:" .. uid .. ":" .. did
  -- push log line onto redis list
  len, err = red_client:rpush(list_key, data)
  red_client:publish(list_key, data)
  if len == 1 then
    ok, err = red_client:rpush("pages:" .. uid, did)
  end
  if len > 50 then
    ok, err = red_client:lpop(list_key)
  end
end

-- TCP connection handler

function tcpserver.connection(uid, did)
  local sock = assert(ngx.req.socket(true))
  local header = sock:receive()
  local uid, did = string.match(header, "(%g*) (%g*)")
  ngx.say("uid is " .. tostring(uid) .. " did is " .. tostring(did))
  if not uid or not did then
    ngx.eof()
    return
  end
  local list_key = "log:" .. uid .. ":" .. did
  
  local red_client = tcpserver.init()

  local ln = sock:receive()
  while ln do
    addlog(red_client, uid, did, ln)
    ln = sock:receive()
  end
end

return tcpserver
