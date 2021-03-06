local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local clickable_container = require('library.ui.clickable-container.no-background')

local sounds = require('theme.sounds')
local system_slider = require('theme.system.slider')

local volume_slider = wibox.widget {
	{
		id = 'slider',
		widget = system_slider
	},
	widget = clickable_container
}

local slider_color_high = volume_slider.slider.critical_color
local slider_color_default = volume_slider.slider.bar_active_color
local slider_color_muted = volume_slider.slider.bar_color

local colorize_slider = function(volume)
	if volume >= 80 then
		volume_slider.slider.bar_active_color = slider_color_high
		volume_slider.slider.handle_color = slider_color_high
	elseif volume <= 0 then
		volume_slider.slider.bar_active_color = slider_color_muted
		volume_slider.slider.handle_color = '#00000000'
	else
		volume_slider.slider.bar_active_color = slider_color_default
		volume_slider.slider.handle_color = slider_color_default
	end
	awesome.emit_signal('icon::volume:update', volume)
end

local update_slider = function()
	awful.spawn.easy_async_with_shell(
		[[bash -c "amixer -D pulse sget Master"]],
		function(stdout)
			local volume = tonumber(string.match(stdout, '(%d?%d?%d)%%'))
      volume_slider.slider:set_value(volume)
      CurrentVolume = volume
		end
	)
end

-- Volume Control functions

local mute_volume = function (state)
	if state == nil then
		awful.spawn('amixer -D pulse set Master 1+ toggle', false)
	elseif state == false then
		awful.spawn('amixer -D pulse set Master 1+ on', false)
	elseif state == true then
		awful.spawn('amixer -D pulse set Master 1+ off', false)
	end
	awesome.emit_signal('widget::volume_icon:mute', state)
end

local set_volume = function (volume)
  CurrentVolume = volume
	awful.spawn('amixer -D pulse sset Master ' .. CurrentVolume .. '%', false)
	mute_volume(false)
end

local increase_volume = function ()
  set_volume(CurrentVolume + 5)
  awful.spawn('paplay ' .. sounds.volume, false)
	update_slider()
end

local decrease_volume = function ()
  set_volume(CurrentVolume - 5)
  awful.spawn('paplay ' .. sounds.volume, false)
	update_slider()
end

-- Control the slider with direct clicking
volume_slider.slider:connect_signal(
	'property::value',
	function()
		local level = volume_slider.slider:get_value()
		set_volume(level)
	end
)

-- Control the slider with the scroll wheel
volume_slider.slider:buttons(
	gears.table.join(
		awful.button(
			{},
			4,
			nil,
			function()
				local level = volume_slider.slider:get_value()
				if level > 100 then
					volume_slider.slider:set_value(100)
					return
				end
				volume_slider.slider:set_value(level + 5)
			end
		),
		awful.button(
			{},
			5,
			nil,
			function()
				local level = volume_slider.slider:get_value()
				if level < 0 then
					volume_slider.slider:set_value(0)
					return
				end
				volume_slider.slider:set_value(level - 5)
			end
		)
	)
)

-- Calls for volume change from external functions

awesome.connect_signal(
	'widget::volume:increase',
	function()
		increase_volume()
	end
)

awesome.connect_signal(
	'widget::volume:decrease',
	function()
		decrease_volume()
	end
)

awesome.connect_signal(
	'widget::volume:set',
	function(value)
		set_volume(value)
	end
)

awesome.connect_signal(
	'widget::volume:mute',
	function(state)
		mute_volume(state)
	end
)

-- Update the slider when opening the side panel
awesome.connect_signal(
	'widget::sliders:update',
	function()
		update_slider()
	end
)

-- Update on startup
update_slider()

return volume_slider