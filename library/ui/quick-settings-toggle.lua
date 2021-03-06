local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local clickable_container = require('library.ui.clickable-container.with-background')

local qs_toggle = function(widget)

  local widget_button = wibox.widget {
    {
      {
        widget,
        margins = dpi(14),
        widget = wibox.container.margin
      },
      forced_width = dpi(72),
      forced_height = dpi(72),
      widget = clickable_container
    },
    activated = nil,
    bg = beautiful.transparent,
    shape = gears.shape.circle,
    widget = wibox.container.background
  }

  return widget_button

end

return qs_toggle