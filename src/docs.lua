local docs = {}

function docs.route(arg1, arg2, method)
  ngx.log(ngx.ERR, type(arg1))
  if not arg1 or (arg1 == "") or (arg1 == "docs") then
    docs.docs()
    return true
  else
    return false
  end
end


function docs.docs()
  ngx.say([[textdash - no-install remote log watching

curl -4 https://textdash.xyz/register/me@example.com

[api key emailed to me@example.com]

curl -4 -X POST -d "im log data" https://textdash.xyz/yourapikey/applicationxyz
curl -4 -X POST -d "im log data also" https://textdash.xyz/yourapikey/applicationxyz
curl -4 https://textdash.xyz/yourapikey/applicationxyz ==> replies "im log data" "im log data also"

Features:

* read a dashboard with header "accept: text/event-stream" and updates will be streamed to you
* as many dashboards as you would like
* logs roll around on a particular dashboard
]])
end

return docs
