local filesystem = require('gears.filesystem')
local config_dir = filesystem.get_configuration_dir()
local sounds     = require('theme.sounds')

-- The default applications that we will use in keybindings and widgets
local default = {
  terminal            = 'alacritty',                                -- Terminal Emulator
  text_editor         = 'xed',                                      -- GUI Text Editor
  web_browser         = 'chromium',                                 -- Web browser
  tor_browser         = 'torbrowser-launcher',                      -- Tor browser
  incognito_browser   = 'chromium --incognito',                     -- Web browser Incognito Mode
  file_manager        = 'nemo',                                  -- GUI File manager
  music_player        = 'youtubemusic-nativefier',                                -- Music Player
  video_player        = 'celluloid',                                -- Video Player
  game                = '/usr/bin/steam-runtime %U',                -- Gaming Library
  ide                 = 'code',                                     -- IDE
  graphics_editor     = 'gimp',                                     -- Graphics Editor
  vector_editor       = 'inkscape',                                     -- Graphics Editor
  video_editor        = 'kdenlive',                                 -- Graphics Editor
  photos_library      = 'digikam',                                  -- Photo Management
  torrent_client      = 'transmission-qt',                          -- Torrent Client
  vpn                 = '/opt/piavpn/bin/pia-client --quiet',       -- VPN Client
  vm                  = 'virtualbox',                               -- VM Emulator

  network_manager     = 'nm-connection-editor',                     -- Network manager
  bluetooth_manager   = 'blueman-manager',                          -- Bluetooth manager
  power_manager       = 'xfce4-power-manager-settings',             -- Power manager
  audio_manager       = 'cinnamon-settings sound',             -- Audio manager
  package_manager     = 'pamac-manager',                            -- GUI Package manager
  lock                = 'cinnamon-screensaver-command -l',          -- Lockscreen
  -- lock                 = 'awesome-client "awesome.emit_signal(\'module::lockscreen_show\')"',  -- Lockscreen
  quake               = 'kitty --name QuakeTerminal',               -- Quake-like Terminal

  rofiglobal          = 'rofi -dpi ' .. screen.primary.dpi ..
                              ' -show "Global Search" -modi "Global Search":' .. config_dir ..
                              '/configuration/rofi/sidebar/rofi-spotlight.sh' ..
                              ' -theme ' .. config_dir ..
                              '/configuration/rofi/sidebar/rofi.rasi',           -- Rofi Web Search

  rofiappmenu         = 'rofi -dpi ' .. screen.primary.dpi ..
                              ' -show drun -theme ' .. config_dir ..
                              '/configuration/rofi/appmenu/rofi.rasi'            -- Application Menu

  -- You can add more default applications here
}

local tool = {
  bashtop = default.terminal .. ' -e bashtop',
}

return {
  default = default,

  -- Apps for the Favorites Widget
  -- you can download any icon to ~/.local/share/icons and it will be picked up by file name minus the extension
  favorites = {
    {
      category = 'Generic',
      apps = {
        {command = default.web_browser, icon = 'chrome'},
        {command = 'google-calendar-dark', icon = 'google-agenda'},
        {command = 'google-keep', icon = 'keep'},
        {command = 'google-drive', icon = 'google-drive'},
        {command = 'GoogleDocs', icon = 'google-docs'},
        {command = default.tor_browser, icon = 'tor'},
      }
    },{
      category = 'Gaming',
      apps = {
        {command = 'lutris', icon = 'lutris'},
        {command = default.game, icon = 'steam'},
        {command = 'obs', icon = 'obs'},
      }
    },{
      category = 'Development',
      apps = {
        {command = default.terminal, icon = 'terminal'},
        {command = default.text_editor, icon = default.text_editor},
        {command = default.ide, icon = default.ide},
      }
    },{
      category = 'Social',
      apps = {
        {command = 'slack', icon = 'slack'},
        {command = 'discord', icon = 'discord'},
        {command = 'whatsapp-nativefier-dark', icon = 'whatsapp'},
      }
    },{
      category = 'Multimedia',
      apps = {
        {command = default.vector_editor, icon = default.vector_editor},
        {command = default.graphics_editor, icon = default.graphics_editor},
        {command = default.photos_library, icon = default.photos_library},
        {command = default.video_editor, icon = default.video_editor},
        {command = default.video_player, icon = 'gnome-mpv'},
        {command = default.music_player, icon = 'youtube-music'},
      }
    },{
      category = 'System',
      apps = {
        {command = default.vm, icon = default.vm},
        {command = default.torrent_client, icon = 'transmission'},
        {command = 'jstest-gtk', icon = 'sc-controller'},
        {command = 'cinnamon-settings', icon = 'utilities-tweak-tool'},
      }
    }
  },

  -- List of apps to start once on start-up
  -- auto-start.lua module will start these
  run_on_start_up = {
    '~/.config/autostart-scripts/autostart.sh'
    -- Set browser as system default
    -- 'xdg-settings set default-web-browser chromium.desktop' .. default.web_browser,

    -- -- Credential manager
    -- '/usr/lib/polkit-kde-authentication-agent-1 &' ..
    -- ' eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)',

    -- -- Auto lock timer
    -- [[
    -- xidlehook --not-when-fullscreen --not-when-audio --timer 600 \
    -- "awesome-client 'awesome.emit_signal(\"module::lockscreen_show\")'" ""
    -- ]],

    -- -- System
    -- 'xfce4-power-manager',                    -- Power manager
    -- 'blueman-applet',                         -- Bluetooth tray icon
    -- 'mpd',                                    -- Music Server
    -- 'xrdb $HOME/.Xresources',                 -- Load X Colors
    -- 'nm-applet',                              -- NetworkManager Applet
    -- 'pulseeffects --gapplication-service',    -- Sound Equalizer
    -- 'redshift-gtk',                           -- Blue light Filter

    -- -- User
    -- 'paplay ' .. sounds.startup,              -- Startup Sound
    -- 'solaar -w hide',                         -- Logitech Unifying Receiver
    -- default.terminal,
    -- default.web_browser,
    -- default.game,
    -- default.vpn

  },
}
