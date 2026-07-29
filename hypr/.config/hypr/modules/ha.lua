local M = {}

local token = os.getenv("HA_TOKEN")
if not token then
	local f = io.open(os.getenv("HOME") .. "/Proyects/dotfiles/.env", "r")
	if f then
		for line in f:lines() do
			local k, v = line:match("^([^=]+)=(.+)$")
			if k == "HA_TOKEN" then
				token = v
			end
		end
		f:close()
	end
end
assert(token, "HA_TOKEN not set and not found in .env")

function M.ha_service(domain, service, json)
	local cmd = string.format(
		[[curl -s \
            -X POST \
            -H 'Authorization: Bearer %s' \
            -H 'Content-Type: application/json' \
            http://100.66.106.112:8123/api/services/%s/%s \
            -d '%s' >/dev/null]],
		token,
		domain,
		service,
		json or "{}"
	)

	return os.execute(cmd)
end

return M
