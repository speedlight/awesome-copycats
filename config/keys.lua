-- Standard awesome library
--local gears = require("gears")
--local awful = require("awful")
require("awful.autofocus")
-- Theme handling library
--local beautiful     = require("beautiful")
-- Notification library
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")

--local modkey       = "Mod4"
--local altkey       = "Mod1"

-- Default applications
local terminal     = "terminator"
local editor       = os.getenv("EDITOR") or "nvim"
local guieditor    = "geany"
local browser      = "brave-browser"
local scrlocker    = "slock"
local mail         = "thunderbird"
local file_manager = "terminator -T ranger --geometry=1024+768+180 -e ranger"
local amixer       = "terminator -T alsamixer --geometry=550x350+240+180 -e alsamixer"
local htop         = "terminator -T htop --geometry=720x380+240+180 -e htop"
local sshooter     = "xfce4-screenshooter"

-- {{{ Key bindings
globalkeys = gears.table.join(
    -- Prompt
    awful.key({ modkey }, "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description = "show help", group="awesome"}),

    -- Tag browsing
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Default client focus
    awful.key({ altkey,           }, "k", function () awful.client.focus.byidx( 1) end,
        {description = "focus next by index", group = "client"}),
    awful.key({ altkey,           }, "j", function () awful.client.focus.byidx(-1) end,
        {description = "focus previous by index", group = "client"}),

    -- By direction client focus
    awful.key({ modkey, "Shift" }, "j",
        function() awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey, "Shift" }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey, "Shift" }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey, "Shift" }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),
    awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ altkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ altkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "toggle wibox", group = "awesome"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- On the fly useless gaps change
    awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(1) end,
              {description = "increment useless gaps", group = "tag"}),
    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
              {description = "decrement useless gaps", group = "tag"}),

    -- Brightness
    awful.key({ "Shift", modkey }, "Prior", function () os.execute("brightnessctl -d intel_backlight s +5%") end,
              {description = "Brightness +5%", group = "hotkeys"}),
    awful.key({ "Shift", modkey }, "Next", function () os.execute("brightnessctl -d intel_backlight s 5%-") end,
              {description = "Brightness -5%", group = "hotkeys"}),

    -- ALSA volume control
    awful.key({ "Control" }, "Up",
        function ()
            os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume up", group = "audio"}),
    awful.key({ "Control" }, "Down",
        function ()
            os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "volume down", group = "audio"}),
    awful.key({ "Control" }, "m",
        function ()
            os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update()
        end,
        {description = "toggle mute", group = "audio"}),

    -- User programs
    awful.key({ modkey }, "e", function () awful.spawn(mail) end,
        {description = "mail (s1t4)", group = "launcher"}),
    awful.key({ modkey }, "q", function () awful.spawn(browser) end,
        {description = "browser (s1t1)", group = "launcher"}),
    awful.key({ modkey }, "a", function () awful.spawn(file_manager) end,
        {description = "file manager", group = "launcher"}),
    awful.key({ modkey }, "p", function () awful.spawn( "xscreensaver-command -activate", false ) end,
        {description = "xscreensaver", group = "hotkeys"}),
    awful.key({ modkey }, "z", function () awful.spawn(amixer) end,
        {description = "amixer", group = "launcher"}),
    awful.key({ }, "Print", function () awful.spawn(sshooter) end,
        {description = "screen_shooter", group = "hotkeys"}),
    awful.key({ modkey }, "h", function () awful.spawn(htop) end,
        {description = "htop", group = "launcher"}),
    awful.key({ modkey }, "l", function () awful.spawn("systemctl suspend", false) end,
        {description = "suspend", group = "hotkeys"}),
    awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"})
)
-- }}}

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "n", function (c) c.minimized = true end,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m", function (c) c.maximized = not c.maximized c:raise() end,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m", function (c) c.maximized_vertical = not c.maximized_vertical c:raise() end,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m", function (c) c.maximized_horizontal = not c.maximized_horizontal c:raise() end,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys, clientkeys)
