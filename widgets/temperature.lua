local wibox = require("wibox")
local watch = require("awful.widget.watch")

-- Configuración centralizada
local config = {
	font = "Play 8",
	colors = {
		low = { bg = "#222222" },
		moderate = { bg = "#FF8200" },
		high = { bg = "#D80000" },
		error = { bg = "#880000" },
	},
}

-- Crear widgets
local temp_text = wibox.widget({
	font = config.font,
	widget = wibox.widget.textbox,
})

local temp_widget = wibox.widget.background()
temp_widget:set_widget(temp_text)

-- Configurar colores iniciales
temp_widget:set_bg(config.colors.low.bg)

-- Función para actualizar colores
local function update_colors(temp)
	if temp < 60 then
		temp_widget:set_bg(config.colors.low.bg)
	elseif temp < 70 then
		temp_widget:set_bg(config.colors.moderate.bg)
	else
		temp_widget:set_bg(config.colors.high.bg)
	end
end

-- Utilizar watch para ejecución periódica
watch("acpi -t", 3, function(_, stdout, stderr, exitreason, exitcode)
	if exitcode == 0 then
		local temp = tonumber(string.match(stdout, "([0-9]+.[0-9]+)"))

		-- Establecer texto de temperatura
		temp_text:set_text(" " .. temp .. "Cº ")

		-- Actualizar colores según la temperatura
		update_colors(temp)
	else
		-- Manejo de errores
		temp_text:set_text("Error")
		temp_widget:set_bg(config.colors.error.bg)
	end

	-- Ejecutar recolección de basura
	collectgarbage()
end, temp_widget)

-- Texto de reserva en caso de error
temp_text:set_text(" ??? ")

-- Exportar el widget creado
return temp_widget
