local awful = require('awful')
local wibox = require("wibox")

local icons = require('theme.icons')
local user_preferences = require('configuration.preferences')

local fallback_icon = icons.symbolic.bluetooth_off

local dynamic_icon = wibox.widget{
	image = fallback_icon,
	resize = true,
	widget = wibox.widget.imagebox
}

awful.widget.watch(
  'rfkill list bluetooth',
  user_preferences.system.icons_update_interval,
  function(_, stdout)
    if stdout:match('Soft blocked: no') then
      dynamic_icon.image = icons.symbolic.bluetooth_on
    else
      dynamic_icon.image = icons.symbolic.bluetooth_off
    end
  end
)

return dynamic_icon