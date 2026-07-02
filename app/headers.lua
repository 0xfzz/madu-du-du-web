local cjson = require("cjson")

local headers = {}

-- lighty.request contains the request headers in lighttpd mod_magnet
for k, v in pairs(lighty.request) do
    headers[k] = v
end

-- Store JSON encoded headers in environment for accesslog format
-- Use lighty.r.req_env for modern lighttpd
if lighty.r and lighty.r.req_env then
    lighty.r.req_env["all_headers"] = " " .. cjson.encode(headers)
else
    lighty.env["all_headers"] = " " .. cjson.encode(headers)
end
