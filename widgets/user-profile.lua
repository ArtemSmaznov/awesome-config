-- User profile widget
-- Optional dependency:
local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local icons = require('theme.icons')

local profile_imagebox = wibox.widget {
	{
		id = 'icon',
		forced_height = dpi(45),
		forced_width = dpi(45),
		image = icons.face,
		clip_shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius) end,
		widget = wibox.widget.imagebox,
		resize = true
	},
	layout = wibox.layout.align.horizontal
}

local profile_name = wibox.widget {
	font = "SF Pro Text Bold 14",
	markup = 'User',
	align = 'right',
	valign = 'center',
	widget = wibox.widget.textbox
}

local distro_name = wibox.widget {
	font = "SF Pro Text Regular 11",
	markup = 'GNU/Linux',
	align = 'right',
	valign = 'center',
	widget = wibox.widget.textbox
}

local kernel_version = wibox.widget {
	font = "SF Pro Text Regular 10",
	markup = 'Linux',
	align = 'right',
	valign = 'center',
	widget = wibox.widget.textbox
}

local uptime_time = wibox.widget {
	font = "SF Pro Text Regular 10",
	markup = 'up 1 minute',
	align = 'right',
	valign = 'center',
	widget = wibox.widget.textbox
}

awful.spawn.easy_async_with_shell(
	"printf \"$(whoami)@$(hostname)\"",
	function(stdout)
		local stdout = stdout:gsub('%\n', '')
		-- stdout = stdout:sub(1,1):upper() .. stdout:sub(2)
		profile_name:set_markup(stdout)
	end
)

awful.spawn.easy_async_with_shell(
	[[
	cat /etc/os-release | awk 'NR==1'| awk -F '"' '{print $2}'
	]],
	function(stdout)
		local distroname = stdout:gsub('%\n', '')
		distro_name:set_markup(distroname)
	end
)

awful.spawn.easy_async_with_shell(
	'uname -r',
	function(stdout)
		local kname = stdout:gsub('%\n', '')
		kernel_version:set_markup(kname)
	end
)

local update_uptime = function()
	awful.spawn.easy_async_with_shell(
		"uptime -p",
		function(stdout)
			local uptime = stdout:gsub('%\n','')
			uptime_time:set_markup(uptime)
		end
	)
end

local uptime_updater_timer = gears.timer{
	timeout = 60,
	autostart = true,
	call_now = true,
	callback = function()
		update_uptime()
	end
}

local user_profile = wibox.widget {
	{
		{
      nil,
      nil,
      {
        {
          layout = wibox.layout.align.vertical,
          expand = 'none',
          nil,
          {
            layout = wibox.layout.fixed.vertical,
            profile_name,
            distro_name,
            kernel_version,
            uptime_time
          },
          nil
        },
        {
          layout = wibox.layout.align.vertical,
          expand = 'none',
          nil,
          profile_imagebox,
          nil
        },
        spacing = dpi(10),
        layout = wibox.layout.fixed.horizontal
      },
      layout = wibox.layout.align.horizontal,
    },
		margins = dpi(10),
		widget = wibox.container.margin
	},
	forced_height = dpi(92),
	bg = beautiful.groups_bg,
	shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius) end,
	widget = wibox.container.background
}

user_profile:connect_signal(
	'mouse::enter',
	function()
		update_uptime()
	end
)

return user_profile
