local wibox = require("wibox")

local icons = require('theme.icons')

local fallback_icon = icons.symbolic.network.wifi_connecting

local dynamic_icon = wibox.widget{
	image = fallback_icon,
	resize = true,
	widget = wibox.widget.imagebox
}

awesome.connect_signal(
  'icon::wifi:update',
  function (signal)
    if signal ~= nil then

      if signal >= 80 then
        dynamic_icon.image = icons.symbolic.network.wifi_5
      elseif signal >= 60 and signal < 80 then
        dynamic_icon.image = icons.symbolic.network.wifi_4
      elseif signal >= 40 and signal < 60 then
        dynamic_icon.image = icons.symbolic.network.wifi_3
      elseif signal >= 20 and signal < 40 then
        dynamic_icon.image = icons.symbolic.network.wifi_2
      elseif signal >= 0 and signal < 20 then
        dynamic_icon.image = icons.symbolic.network.wifi_1
      else
        dynamic_icon.image = icons.symbolic.network.wifi_error
      end

    else
      dynamic_icon.image = icons.symbolic.network.wifi_off
    end
  end
)

return dynamic_icon