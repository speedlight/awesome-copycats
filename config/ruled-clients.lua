local awful = require("awful")
local beautiful = require("beautiful")

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = keys.clientkeys,
                     buttons = keys.clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Titlebars
    { rule_any = { 
        type = { "dialog", "normal" } 
      },
      properties = { titlebars_enabled = false } 
    },

    { rule = { class = "Firefox" },
      properties = { screen = 1, tag = awful.util.tagnames[1] } },
    { rule = { class = "Thunderbird" },
      properties = { screen = 1, tag = awful.util.tagnames[4] } },

    -- Scripts to float.
    { rule = { name = "htop" },
      properties = { floating = true, titlebars_enabled = false } },
    { rule = { name = "ranger" },
      properties = { floating = true, titlebars_enabled = false } },
    { rule = { name = "vwsbx", class= "VWorkflow" },
      properties = { floating = true,
        titlebars_enabled = false,
        geometry = { x = 150, y = 150, width = 200, height = 300 } 
      } },
    { rule = { name = "amixer" },
      properties = { floating = true } },
    { rule_any = {
        class = {
          "Arandr",
          "Blueman-manager",
          "Wpa_gui",
        },
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }
    },
}
