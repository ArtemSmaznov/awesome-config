local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local icons = require('theme.icons')

local clickable_container = require('library.ui.clickable-container.with-background')
local dpi = require('beautiful').xresources.apply_dpi


local docu_widget =  wibox.widget {
  {
    image = icons.places.documents_folder,
    resize = true,
    widget = wibox.widget.imagebox
  },
  layout = wibox.layout.align.horizontal
}

local docu_button = wibox.widget {
  {
    docu_widget,
    margins = dpi(5),
    widget = wibox.container.margin
  },
  widget = clickable_container
}

docu_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn.with_shell('xdg-open $(xdg-user-dir DOCUMENTS)')
      end
    )
  )
)

awful.tooltip(
  {
    objects = {docu_button},
    mode = 'outside',
    align = 'right',
    text = 'Documents',
    margin_leftright = dpi(8),
    margin_topbottom = dpi(8),
    preferred_positions = {'right', 'left', 'top', 'bottom'}
  }
)

return docu_button
