local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi

local icons = require('theme.icons')

local build = function(s)

  local panel_margins = dpi(0)
  local panel_height = s.geometry.height - 2 * panel_margins

  local blur_slider_visible = false
  local panel_visible = false

  -- ░█▀▄░█▀▄░▀█▀░█▀▀░█░█░▀█▀░█▀█░█▀▀░█▀▀░█▀▀░░░█▀▀░█░░░▀█▀░█▀▄░█▀▀░█▀▄
  -- ░█▀▄░█▀▄░░█░░█░█░█▀█░░█░░█░█░█▀▀░▀▀█░▀▀█░░░▀▀█░█░░░░█░░█░█░█▀▀░█▀▄
  -- ░▀▀░░▀░▀░▀▀▀░▀▀▀░▀░▀░░▀░░▀░▀░▀▀▀░▀▀▀░▀▀▀░░░▀▀▀░▀▀▀░▀▀▀░▀▀░░▀▀▀░▀░▀

  s.brightness_slider = wibox.widget {
    {
      {
        {
          image = icons.symbolic.brightness.high,
          resize = true,
          widget = wibox.widget.imagebox
        },
        top = dpi(10),
        bottom = dpi(10),
        widget = wibox.container.margin
      },
      require('library.sliders.brightness'),
      spacing = dpi(24),
      layout = wibox.layout.fixed.horizontal
    },
    left = dpi(24),
    right = dpi(24),
    forced_height = dpi(48),
    widget = wibox.container.margin
  }

  -- ░█░█░█▀█░█░░░█░█░█▄█░█▀▀░░░█▀▀░█░░░▀█▀░█▀▄░█▀▀░█▀▄
  -- ░▀▄▀░█░█░█░░░█░█░█░█░█▀▀░░░▀▀█░█░░░░█░░█░█░█▀▀░█▀▄
  -- ░░▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░░░▀▀▀░▀▀▀░▀▀▀░▀▀░░▀▀▀░▀░▀

  s.volume_slider = wibox.widget {
    {
      {
        id = 'icon',
        require('library.dynamic-icons.volume'),
        top = dpi(10),
        bottom = dpi(10),
        widget = wibox.container.margin
      },
      id = 'body',
      require('library.sliders.volume'),
      spacing = dpi(24),
      layout = wibox.layout.fixed.horizontal
    },
    left = dpi(24),
    right = dpi(24),
    forced_height = dpi(48),
    widget = wibox.container.margin
  }

  s.volume_slider.body.icon:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          awesome.emit_signal('widget::volume:mute', nil)
        end
      )
    )
  )

  -- ░█▀▄░█░░░█░█░█▀▄░░░█▀▀░█░░░▀█▀░█▀▄░█▀▀░█▀▄
  -- ░█▀▄░█░░░█░█░█▀▄░░░▀▀█░█░░░░█░░█░█░█▀▀░█▀▄
  -- ░▀▀░░▀▀▀░▀▀▀░▀░▀░░░▀▀▀░▀▀▀░▀▀▀░▀▀░░▀▀▀░▀░▀

  s.blur_slider = require('library.sliders.blur')
  s.blur_slider.visible = blur_slider_visible

  awesome.connect_signal(
    'widget::blur:slider:toggle',
    function()
      if not blur_slider_visible then
        blur_slider_visible = true
        s.blur_slider.visible = blur_slider_visible
      else
        blur_slider_visible = false
        s.blur_slider.visible = blur_slider_visible
      end
    end
  )

  -- ░█▀█░█▀█░█▀█░█▀▀░█░░░█▀▀
  -- ░█▀▀░█▀█░█░█░█▀▀░█░░░▀▀█
  -- ░▀░░░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀

  local first_column = wibox.widget {
    s.brightness_slider,
    require('widgets.quick-settings'),
    s.blur_slider,
    s.volume_slider,
    require('widgets.weather'),
    require('widgets.notif-center')(s),
    spacing = dpi(7),
    forced_width = dpi(500),
    layout = wibox.layout.fixed.vertical
  }

  local second_column = wibox.widget {
    require('widgets.user-profile'),
    require('widgets.hardware-monitor'),
    require('widgets.disk-usage'),
    -- require('widgets.social-media'),
    -- require('widgets.calculator'),
    spacing = dpi(7),
    forced_width = dpi(300),
    layout = wibox.layout.fixed.vertical
  }

  local notif_tray = awful.popup {
    widget = {
      {
        {
          first_column,
          second_column,
          spacing = dpi(7),
          layout = wibox.layout.fixed.horizontal
        },
        margins = dpi(16),
		    widget = wibox.container.margin
      },
			bg = beautiful.background,
      widget = wibox.container.background()
    },
    ontop = true,
    type = 'toolbar',
    maximum_height = s.geometry.height,
    maximum_width = s.geometry.width/2,
    bg = beautiful.transparent,
    screen = s,
    visible = false,
    placement = awful.placement.top
     + awful.placement.no_offscreen,
  }

  s.backdrop_notif = wibox
	{
		ontop = true,
		screen = s,
		bg = beautiful.transparent,
    type = 'utility',
		x = s.geometry.x,
		y = s.geometry.y,
		width = s.geometry.width,
		height = s.geometry.height
	}

  function notif_tray:open()
		local focused = awful.screen.focused()
    focused.backdrop_notif.visible = true
    focused.notif_tray.visible = true
    awesome.emit_signal('notification_tray:opened')
	end

  function notif_tray:close()
		local focused = awful.screen.focused()
    focused.backdrop_notif.visible = false
    focused.notif_tray.visible = false
    awesome.emit_signal('notification_tray:closed')
	end

  function notif_tray:toggle()
    if panel_visible then
      notif_tray:close()
      panel_visible = false
    else
      notif_tray:open()
      panel_visible = true
    end
    awesome.emit_signal('modules:update')
  end

  s.backdrop_notif:connect_signal(
    'button::press',
    function()
      notif_tray:toggle()
    end
  )

  return notif_tray
end

return build