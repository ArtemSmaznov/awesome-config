local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')

local dpi = beautiful.xresources.apply_dpi
local icons = require('theme.icons')

local tag_list = require('widget.panel-widgets.tag-list')
local clickable_container = require('widget.clickable-container.with-background')

return function(s, panel, action_bar_width)

	local menu_icon = wibox.widget {
		{
			id = 'menu_btn',
			image = icons.other.gear,
			resize = true,
			widget = wibox.widget.imagebox
		},
		margins = dpi(10),
		widget = wibox.container.margin
	}
	
	local home_button = wibox.widget {
		{
			menu_icon,
			widget = clickable_container
		},
		bg = beautiful.background .. '66',
		widget = wibox.container.background
	}

	home_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					panel:toggle()
				end
			)
		)
	)

	panel:connect_signal(
		'opened',
		function()
			menu_icon.menu_btn:set_image(gears.surface(icons.ui.close))
			awesome.emit_signal('widget::toggles:update')
			awesome.emit_signal('widget::sliders:update')
		end
	)

	panel:connect_signal(
		'closed',
		function()
			menu_icon.menu_btn:set_image(gears.surface(icons.other.gear))
			awesome.emit_signal('widget::toggles:update')
			awesome.emit_signal('widget::sliders:update')
		end
	)

	return wibox.widget {

		id = 'action_bar',
		layout = wibox.layout.align.vertical,
		forced_width = action_bar_width,
		{
			require('widget.panel-widgets.start')(),
			require('widget.separator')('h'),
			tag_list(s),
			require('widget.separator')('h'),
			require("widget.panel-widgets.xdg-folders"),
			require('widget.separator')('h'),
			layout = wibox.layout.fixed.vertical,
		},
		nil,
		{
			require('widget.panel-widgets.system-tray')(s, action_bar_width),
			home_button,
			layout = wibox.layout.fixed.vertical,
		}
	}
end
