local wibox = require("wibox")
local watch = require("awful.widget.watch")

-- Configuración centralizada
local config = {
	font = "Play 9",
	text_color = "#222222",
	colors = {
		low = { bg = "#222222", fg = "#ffffff" },
		moderate = { bg = "#AB7300", fg = "#ffffff" },
		high = { bg = "#ff0000", fg = "#ffffff" },
		error = { bg = "#880000", fg = "#ffffff" },
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
temp_widget:set_fg(config.colors.low.fg)

-- Función para actualizar colores
local function update_colors(temp)
	if temp < 60 then
		temp_widget:set_bg(config.colors.low.bg)
		temp_widget:set_fg(config.colors.low.fg)
	elseif temp < 70 then
		temp_widget:set_bg(config.colors.moderate.bg)
		temp_widget:set_fg(config.colors.moderate.fg)
	else
		temp_widget:set_bg(config.colors.high.bg)
		temp_widget:set_fg(config.colors.high.fg)
	end
end

-- Utilizar watch para ejecución periódica
watch("acpi -t", 5, function(_, stdout, stderr, exitreason, exitcode)
	if exitcode == 0 then
		local temp = tonumber(string.match(stdout, "([0-9]+.[0-9]+)"))

		-- Establecer texto de temperatura
		temp_text:set_text("  " .. temp .. "Cº  ")

		-- Actualizar colores según la temperatura
		update_colors(temp)
	else
		-- Manejo de errores
		temp_text:set_text("Error")
		temp_widget:set_bg(config.colors.error.bg)
		temp_widget:set_fg(config.colors.error.fg)
	end

	-- Ejecutar recolección de basura
	collectgarbage()
end, temp_widget)

-- Texto de reserva en caso de error
temp_text:set_text(" ??? ")

-- Exportar el widget creado
return temp_widget
