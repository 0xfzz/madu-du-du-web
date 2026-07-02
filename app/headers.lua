local cjson = require("cjson")

local headers = {}

-- lighty.request in newer lighttpd gives all request headers
-- We iterate through the environment for request.header.* as a fallback/standard way
for k, v in pairs(lighty.env) do
    -- lighty.env contains request headers prefixed with 'request.header.'
    local prefix = "request.header."
    if string.sub(k, 1, string.len(prefix)) == prefix then
        local header_name = string.sub(k, string.len(prefix) + 1)
        headers[header_name] = v
    end
end

-- Fallback: if empty, try lighty.request if it exists (newer lighttpd 1.4.x)
if next(headers) == nil and lighty.request then
    for k, v in pairs(lighty.request) do
        headers[k] = v
    end
end

-- Store JSON encoded headers in environment for accesslog format
lighty.env["all_headers"] = " " .. cjson.encode(headers)
