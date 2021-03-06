local awful = require('awful')
local gears = require('gears')
local ruled = require("ruled")
local beautiful = require('beautiful')

local client_keys = require('configuration.client.keys')
local client_buttons = require('configuration.client.buttons')

local current_tag

ruled.client.connect_signal(
	"request::rules",
  function()

    -- ░█▀▀░█▀▀░█▀█░█▀▀░█▀▄░█▀█░█░░
    -- ░█░█░█▀▀░█░█░█▀▀░█▀▄░█▀█░█░░
    -- ░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀
    -- All clients will match this rule.

		ruled.client.append_rule {
			id                     = "global",
			rule                   = { },
			properties             = {
        focus                = awful.client.focus.filter,
        switchtotag          = true,
				raise                = true,
				floating             = false,
				maximized            = false,
				above                = false,
				below                = false,
				ontop                = false,
				sticky               = false,
				maximized_horizontal = false,
				maximized_vertical   = false,
				round_corners        = false,
				keys                 = client_keys,
				buttons              = client_buttons,
				screen               = 'primary', -- new clients default to primary screen
				-- screen            = awful.screen.preferred, -- new clients default to focused screen
				placement            = awful.placement.no_overlap + awful.placement.no_offscreen + awful.placement.centered
			}
		}

    -- ░▀█▀░█▀▀░█▀▄░█▄█░▀█▀░█▀█░█▀█░█░░░░░▀█▀░█▀█░█▀▀
    -- ░░█░░█▀▀░█▀▄░█░█░░█░░█░█░█▀█░█░░░░░░█░░█▀█░█░█
    -- ░░▀░░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀░░░░▀░░▀░▀░▀▀▀

		ruled.client.append_rule {
			id         = "terminals",
			rule_any   = {
				class = {
					"URxvt",
					"XTerm",
					"UXTerm",
					"kitty",
					"K3rmit",
					"Terminator",
					"Alacritty"
				}
			},
			except_any = {
				instance = { "QuakeTerminal" }
			},
			properties = {
        tag = 'coding',
        hide_titlebars = true,
				size_hints_honor = false
			}
		}

		ruled.client.append_rule {
			id         = "sides",
			rule_any   = {
				class = {
          "whatsapp",
          "Slack",
          "discord",
          "obs",
          "Spotify",
          "youtubemusic"
          }
			},
			properties = {
        tag = 'misc',
        screen = awful.tag.find_by_name(nil, 'misc').screen,
			}
		}

    -- ░▀█▀░█▀█░▀█▀░█▀▀░█▀▄░█▀█░█▀▀░▀█▀░░░▀█▀░█▀█░█▀▀
    -- ░░█░░█░█░░█░░█▀▀░█▀▄░█░█░█▀▀░░█░░░░░█░░█▀█░█░█
    -- ░▀▀▀░▀░▀░░▀░░▀▀▀░▀░▀░▀░▀░▀▀▀░░▀░░░░░▀░░▀░▀░▀▀▀

    ruled.client.append_rule {
			id         = "web_browsers",
			rule_any   = {
				class = {
					"firefox",
					"Tor Browser",
					"Chromium",
					"Google-chrome"
				}
			},
			properties = {
        tag = 'internet',
        screen = 1,
        hide_titlebars = true,
        round_corners = false,
        skip_decoration = true
			}
		}

    -- ░█▀▀░█▀█░█▄█░▀█▀░█▀█░█▀▀░░░▀█▀░█▀█░█▀▀
    -- ░█░█░█▀█░█░█░░█░░█░█░█░█░░░░█░░█▀█░█░█
    -- ░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀▀░░░░▀░░▀░▀░▀▀▀

    ruled.client.append_rule {
			id         = "gaming",
			rule_any   = {
				class = {
					"Wine",
					"dolphin-emu",
					"Lutris",
					"Citra",
					"SuperTuxKart",
				},
				name = {
					"GOG Galaxy",
					"Steam",
				},
      },
      except_any = {
        name = {
					"- Steam",
          "Steam Guard"
				}
      },
			properties = {
        tag = 'gaming',
        screen = 1,
        switchtotag = false,
        skip_decoration = true,
				hide_titlebars = true,
				round_corners = false,
				placement = awful.placement.centered
			}
		}

    ruled.client.append_rule {
			id         = "steam",
			rule_any   = {
				instance = {
					"Steam",
				}
			},
			properties = {
        tag = 'gaming',
        screen = 1,
        round_corners = false,
        hide_titlebars = true,
        placement = awful.placement.centered
			}
		}

    ruled.client.append_rule {
			id         = "steam_friends",
			rule_any   = {
				name = {
					"Friends List",
				}
			},
			properties = {
        width = 400,
        maximized_vertical = true,
        placement = awful.placement.right
			}
		}

		ruled.client.append_rule {
			id         = "games",
			rule_any   = {
				class = {
					"steam_app",
        },
        name = {
					"Witcher",
				}
      },
      except_any = {
        name = {
					"Steam",
				}
      },
			properties = {
        tag = 'gaming',
        screen = 1,
				skip_decoration = true,
				maximized = false,
				fullscreen = true,
				hide_titlebars = true,
				round_corners = false,
				placement = awful.placement.centered
			}
		}

    -- ░█▀▄░█▀▀░█░█░░░▀█▀░█▀█░█▀▀
    -- ░█░█░█▀▀░▀▄▀░░░░█░░█▀█░█░█
    -- ░▀▀░░▀▀▀░░▀░░░░░▀░░▀░▀░▀▀▀

		ruled.client.append_rule {
			id         = "dev",
			rule_any   = {
        class = {
          "Geany",
          "Atom",
          "Subl3",
          "code-oss",
          "Cypress",
          "Oomox",
          "Unity",
          "UnityHub",
          "jetbrains-studio"
        },
        name  = {
          "LibreOffice",
          "libreoffice",
          "cypress"
        }
      },
			properties = {
        tag = 'coding',
        screen = 1,
			}
		}

    -- ░█▀▀░█▀█░█▄█░█▀█░█░█░▀█▀░█▀▀░█▀▄░░░▀█▀░█▀█░█▀▀
    -- ░█░░░█░█░█░█░█▀▀░█░█░░█░░█▀▀░█▀▄░░░░█░░█▀█░█░█
    -- ░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░░▀░░▀▀▀░▀░▀░░░░▀░░▀░▀░▀▀▀

		ruled.client.append_rule {
			id         = "computer",
			rule_any   = {
        class = {
          "dolphin",
          "ark",
          "Nemo",
          "File-roller",
          "googledocs",
          "keep",
          "calendar"
        }
      },
			properties = {
        tag = 'computer',
        screen = 1,
			}
		}

    -- ░█▄█░█░█░█░░░▀█▀░▀█▀░█▄█░█▀▀░█▀▄░▀█▀░█▀█░░░▀█▀░█▀█░█▀▀
    -- ░█░█░█░█░█░░░░█░░░█░░█░█░█▀▀░█░█░░█░░█▀█░░░░█░░█▀█░█░█
    -- ░▀░▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░▀░▀▀▀░▀▀░░▀▀▀░▀░▀░░░░▀░░▀░▀░▀▀▀

		ruled.client.append_rule {
			id         = "multimedia",
			rule_any   = {
        class = {
          "vlc",
          "Celluloid",
        }
      },
			properties = {
        tag = 'multimedia',
        screen = 1,
			}
		}

    -- ░█▀▀░█▀▄░█▀█░█▀█░█░█░▀█▀░█▀▀░█▀▀░░░▀█▀░█▀█░█▀▀
    -- ░█░█░█▀▄░█▀█░█▀▀░█▀█░░█░░█░░░▀▀█░░░░█░░█▀█░█░█
    -- ░▀▀▀░▀░▀░▀░▀░▀░░░▀░▀░▀▀▀░▀▀▀░▀▀▀░░░░▀░░▀░▀░▀▀▀

		ruled.client.append_rule {
			id         = "graphics",
			rule_any   = {
        class = {
          "Gimp-2.10",
          "Gimp",
          "Inkscape",
          "Flowblade",
          "digikam",
        }
      },
			properties = {
        tag = 'graphics',
        screen = 1,
        round_corners = false,
        hide_titlebars = true,
        skip_decoration = true
			}
		}

    -- ░█▀▀░█▀█░█▀█░█▀▄░█▀▄░█▀█░█░█░░░▀█▀░█▀█░█▀▀
    -- ░▀▀█░█▀█░█░█░█░█░█▀▄░█░█░▄▀▄░░░░█░░█▀█░█░█
    -- ░▀▀▀░▀░▀░▀░▀░▀▀░░▀▀░░▀▀▀░▀░▀░░░░▀░░▀░▀░▀▀▀

		ruled.client.append_rule {
			id         = "sandbox",
			rule_any   = {
        class = {
          "VirtualBox Manage",
          "VirtualBox Machine"
        }
      },
			properties = {
        tag = 'sandbox',
        screen = 1,
			}
		}

    -- ░█▀▀░█░█░█▀▀░▀█▀░█▀▀░█▄█
    -- ░▀▀█░░█░░▀▀█░░█░░█▀▀░█░█
    -- ░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░▀░▀

    -- Image viewers with splash-like behaviour
		ruled.client.append_rule {
			id        = "splash_like",
			rule_any  = {
				class    = {
					"feh",
					"Pqiv",
					"Sxiv"
				},
				name = {"Discord Updater"}
			},
			properties = {
				skip_decoration = true,
				hide_titlebars = true,
				floating = true,
				ontop = true,
				placement = awful.placement.centered
			}
		}

		-- Dialogs
		ruled.client.append_rule {
			id         = "dialog",
			rule_any   = {
				type  = { "dialog",  },
				class = { "Wicd-client.py", "calendar.google.com" }
			},
			properties = {
        titlebars_enabled = true,
				maximized = false,
				floating = true,
				above = true,
				draw_backdrop = true,
				skip_decoration = true,
        hide_titlebars = false,
        round_corners = true,
				placement = awful.placement.centered
      },
      callback = function (c)
        c:move_to_tag(awful.screen.focused().selected_tag)
      end,
		}

		-- Modals
		ruled.client.append_rule {
			id         = "dialog",
			rule_any   = {
				type = {
					"modal",
					"dialog"
				},
				name = {
					"Open File",
					"Save File"
				}
			},
			properties = {
				titlebars_enabled = true,
				floating = true,
				above = true,
				draw_backdrop = true,
				-- skip_decoration = true,
				shape = function(cr, width, height)
							gears.shape.rounded_rect(cr, width, height, beautiful.client_radius)
						end,
				placement = awful.placement.centered
			}
		}

		-- Utilities
		ruled.client.append_rule {
			id         = "utility",
			rule_any   = {
				type = { "utility" }
			},
			properties = {
				titlebars_enabled = false,
				floating = true,
				hide_titlebars = true,
				draw_backdrop = false,
				skip_decoration = true,
				placement = awful.placement.centered
			}
		}

		-- Splash
		ruled.client.append_rule {
			id         = "splash",
			rule_any   = {
				type = { "splash" }
			},
			properties = {
				titlebars_enabled = false,
				floating = true,
				above = true,
				hide_titlebars = true,
				draw_backdrop = false,
				skip_decoration = true,
				shape = function(cr, width, height)
							gears.shape.rounded_rect(cr, width, height, beautiful.client_radius)
						end,
				placement = awful.placement.centered
			}
		}

		-- Splash-like but with titlebars enabled
		ruled.client.append_rule {
			id       = "instances",
			rule_any = {
				instance    = {
					"file_progress",
					"Popup",
					"nm-connection-editor",
				},
				class = {
					"scrcpy" ,
					"Mugshot",
					"Pulseeffects"
				}
			},
				properties = {
				skip_decoration = true,
				round_corners = true,
				ontop = true,
				floating = true,
				draw_backdrop = false,
				focus = awful.client.focus.filter,
				raise = true,
				keys = client_keys,
				buttons = client_buttons,
				placement = awful.placement.centered
			}
		}

		-- Fullsreen
		ruled.client.append_rule {
			id       = "fullscreen",
			rule_any = {
				class    = {
					"SuperTuxKart"
				}
			},
			properties = {
				skip_decoration = true,
				round_corners = false,
				ontop = true,
				floating = false,
				fullscreen = true,
				draw_backdrop = false,
				raise = true,
				keys = client_keys,
				buttons = client_buttons,
				placement = awful.placement.centered
			}
		}

	end
)


-- Normally we'd do this with a rule, but other apps like spotify and supertuxkart doesn't set its class or name
-- until after it starts up, so we need to catch that signal.

-- If the application is fullscreen in its settings, make sure to set `c.fullscreen = false` first
-- before moving to the desired tag or else the tag where the program spawn will cause panels to hide.
-- After moving the program to specified tag you can set `c.fullscreen = true` now
-- See what I did in `SuperTuxKart`

client.connect_signal(
	"property::class",
	function(c)
		if c.class == "Spotify" then
			-- Check if Spotify is already open
			local spotify = function (c)
				return ruled.client.match(c, { class = "Spotify" })
			end

			local spotify_count = 0
			for c in awful.client.iterate(spotify) do
				spotify_count = spotify_count + 1
			end

			-- If Spotify is already open, don't open a new instance
			if spotify_count > 1 then
				c:kill()
				-- Switch to previous instance
				for c in awful.client.iterate(spotify) do
					c:jump_to(false)
				end
			else
				-- Move the Spotify instance to "5" tag on this screen
				local t = awful.tag.find_by_name(awful.screen.focused(), "5")
				c:move_to_tag(t)
			end
		elseif c.class == "SuperTuxKart" then
			-- Disable fullscreen first
			c.fullscreen = false

			-- Check if SuperTuxKart is already open
			local stk = function (c)
				return ruled.client.match(c, { class = "SuperTuxKart" })
			end

			local stk_count = 0
			for c in awful.client.iterate(stk) do
				stk_count = stk_count + 1
			end

			-- If SuperTuxKart is already open, don't open a new instance
			if stk_count > 1 then
				c:kill()
				-- Switch to previous instance
				for c in awful.client.iterate(stk) do
					c:jump_to(false)
				end
			else
				-- Move the instance to specified tag tag on this screen
				local t = awful.tag.find_by_name(awful.screen.focused(), "6")
				c:move_to_tag(t)
				t:view_only()
				-- Enable fullscreeen again
				c.fullscreen = true
			end
		end

	end
)
