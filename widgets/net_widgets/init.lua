local module_path = (...):match("(.+/)[^/]+$") or ""

package.loaded.net_widgets = nil

local net_widgets = {
	indicator = require(module_path .. "widgets.net_widgets.indicator"),
}

return net_widgets
