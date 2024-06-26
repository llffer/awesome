local module_path = (...):match("(.+/)[^/]+$") or ""

package.loaded.network = nil

local network = {
	indicator = require(module_path .. "widgets.network.indicator"),
}

return network
