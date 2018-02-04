--Configure home path so you dont have too
home_path  = os.getenv('HOME') .. '/'

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- beautiful.init( awful.util.getdir("config") .. "/themes/zenburn/theme.lua" )

-- for themes in $HOME/.config/awesome/themes - default sky zenburn
beautiful.init(awful.util.getdir("config") .. "/themes/default/theme.lua")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
--FreeDesktop
require('freedesktop.utils')
require('freedesktop.menu')
freedesktop.utils.icon_theme = 'gnome'
--Vicious + Widgets
vicious = require("vicious")
local wi = require("wi")

-- enable autostart file
awful.spawn.with_shell("~/.config/awesome/autorun.sh")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
                   title = "Oops, there were errors during startup!",
                   text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
                           -- Make sure we don't go into an endless error loop
                           if in_error then return end
                           in_error = true

                           naughty.notify({ preset = naughty.config.presets.critical,
                                            title = "Oops, an error happened!",
                                            text = err })
                           in_error = false
  end)
end
-- }}}

-- This is used later as the default terminal and editor to run.
terminal = "st"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
rmenu = "rofi-gorice"
rexit = "rofi-logout"
guimenu = "jgmenu --config-file=/home/doug/.config/jgmenu/jgawesomerc"
browser = "firefox"
mail = "thunderbird"
filemgr = "thunar"
txteditor = "subl3"
art = "gimp"
volumeup =   "amixer -q sset Master 5%+ unmute"
volumedown = "amixer -q sset Master 5%- unmute"
volumemute = "amixer sset Master,0 toggle"
writer = "libreoffice --writer"
ssheet = "libreoffice --calc"
calculator = "galculator"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
  {
    awful.layout.suit.tile,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.max,
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.magnifier
  }
-- }}}

-- {{{ Naughty presets
naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.position = "top_right"
naughty.config.defaults.margin = 8
naughty.config.defaults.gap = 1
naughty.config.defaults.ontop = true
naughty.config.defaults.font = "Roboto Mono 10"
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = 256
naughty.config.defaults.fg = beautiful.fg_tooltip
naughty.config.defaults.bg = beautiful.bg_tooltip
naughty.config.defaults.border_color = beautiful.border_tooltip
naughty.config.defaults.border_width = 2
naughty.config.defaults.hover_timeout = nil
-- -- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
  for s = 1, screen.count() do
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
  end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
  names  = {
--    ':1',
--    ':2',
--    ':3',
--    ':4',
--    ':5',
--    ':6',
--    ':7',
--    ':8',
--    ':9',
       ' 1. ',
       ' 2. ',
       ' 3. ',
       ' 4. ',
  },
  layout = {
    layouts[1],   -- 1:1
    layouts[2],  -- 2:2
    layouts[3],  -- 3:3
    layouts[4],  -- 4:4
    --layouts[5],   -- 5:5
    --layouts[6],  -- 6:6
    --layouts[10],  -- 7:7
    --layouts[20],   -- 8:8
    --layouts[10],  -- 9:9
  }
}
for s = 1, screen.count() do
  -- Each screen has its own tag table.
  tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- Wallpaper Changer Based On
-- menu icon menu pdq 07-02-2012
local wallmenu = {}
local function wall_load(wall)
  local f = io.popen('ln -sfn ' .. '/mnt/public/images/' .. wall .. ' ' .. home_path .. '.config/awesome/themes/default/bg.png')
  awesome.restart()
end
local function wall_menu()
  local f = io.popen('ls -1 ' .. '/mnt/public/images/')
  for l in f:lines() do
    local item = { l, function () wall_load(l) end }
    table.insert(wallmenu, item)
  end
  f:close()
end
wall_menu()

-- Widgets

spacer       = wibox.widget.textbox()
spacer:set_text('    ')

--Weather Widget
-- weather = wibox.widget.textbox()
-- vicious.register(weather, vicious.widgets.weather, "Weather: ${city}. Sky: ${sky}. Temp: ${tempc}c Humid: ${humid}%. Wind: ${windkmh} KM/h", 1200, "YMML")

--Battery Widget
-- batt = wibox.widget.textbox()
-- vicious.register(batt, vicious.widgets.bat, "Batt: $2% Rem: $3", 61, "BAT0")


-- {{{ Menu
-- Create a laucher widget and a main menu

menu_items = freedesktop.menu.new()
myawesomemenu = {
  { "manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
  { "restart", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'edit-undo' }) },
  { "quit", function() awesome.quit() end, freedesktop.utils.lookup_icon({ icon = 'system-shutdown' }) },
}
-- { "quit", awesome.quit, freedesktop.utils.lookup_icon({ icon = 'system-shutdown' }) }

table.insert(menu_items, { "Awesome", myawesomemenu, beautiful.awesome_icon })
table.insert(menu_items, { "Wallpaper", wallmenu, freedesktop.utils.lookup_icon({ icon = 'gnome-settings-background' })})

mymainmenu = awful.menu({ items = menu_items, width = 200 })
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
myinfowibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
  awful.button({ }, 1, awful.tag.viewonly),
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, awful.client.toggletag),
  awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
      if c == client.focus then
        c.minimized = true
      else
        -- Without this, the following
        -- :isvisible() makes no sense
        c.minimized = false
        if not c:isvisible() then
          awful.tag.viewonly(c:tags()[1])
        end
        -- This will also un-minimize
        -- the client, if needed
        client.focus = c
        c:raise()
      end
  end),
  awful.button({ }, 3, function ()
      if instance then
        instance:hide()
        instance = nil
      else
        instance = awful.menu.clients({ width=200 })
      end
  end),
  awful.button({ }, 4, function ()
      awful.client.focus.byidx(1)
      if client.focus then client.focus:raise() end
  end),
  awful.button({ }, 5, function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
  end)
)

for s = 1, screen.count() do
  -- Create a promptbox for each screen
  mypromptbox[s] = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  mylayoutbox[s] = awful.widget.layoutbox(s)
  mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
  -- Create a taglist widget
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

  -- Create a tasklist widget
  mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

  -- Create the wibox
  mywibox[s] = awful.wibox({ position = "top", screen = s })

  -- Widgets that are aligned to the left
  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(mylauncher)
  left_layout:add(mytaglist[s])
  left_layout:add(mypromptbox[s])

  -- Widgets that are aligned to the right
  local right_layout = wibox.layout.fixed.horizontal()
  if s == 1 then right_layout:add(wibox.widget.systray()) end
--  right_layout:add(spacer)
  right_layout:add(spacer)
  right_layout:add(cpuicon)
  right_layout:add(cpu)
  right_layout:add(spacer)
  right_layout:add(memicon)
  right_layout:add(mem)
  right_layout:add(spacer)
--  right_layout:add(wifiicon)
  right_layout:add(netwidget)
--  right_layout:add(baticon)
--  right_layout:add(batpct)
--  right_layout:add(spacer)
--  right_layout:add(pacicon)
--  right_layout:add(pacwidget)
--  right_layout:add(spacer)
--  right_layout:add(neticon)
--  right_layout:add(netwidget)
--  right_layout:add(volicon)
--  right_layout:add(volpct)
--  right_layout:add(volspace)
  right_layout:add(spacer)
  right_layout:add(mytextclock)
  right_layout:add(spacer)
  right_layout:add(mylayoutbox[s])

  -- Now bring it all together (with the tasklist in the middle)
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(mytasklist[s])
  layout:set_right(right_layout)

  mywibox[s]:set_widget(layout)

  -- Create the bottom wibox
--  myinfowibox[s] = awful.wibox({ position = "bottom", screen = s })
  -- Widgets that are aligned to the bottom
--  local bottom_layout = wibox.layout.fixed.horizontal()
--  bottom_layout:add(cpuicon)
--  bottom_layout:add(cpu)
--  bottom_layout:add(spacer)
--  bottom_layout:add(memicon)
--  bottom_layout:add(mem)
--  bottom_layout:add(spacer)
--  bottom_layout:add(wifiicon)
--  bottom_layout:add(wifi)
--  bottom_layout:add(spacer)
--  bottom_layout:add(weather)
--  bottom_layout:add(spacer)

  -- Now bring it all together
  --local layout = wibox.layout.align.horizontal()
  --layout:set_bottom(bottom_layout)

--  myinfowibox[s]:set_widget(bottom_layout)

end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
               awful.button({ }, 3, function () mymainmenu:toggle() end),
               awful.button({ }, 1, function () awful.util.spawn(guimenu) end)
               -- awful.button({ }, 4, awful.tag.viewnext),
               -- awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  awful.key({ altkey,  "Control"    }, "Left",   awful.tag.viewprev       ),
  awful.key({ altkey,  "Control"    }, "Right",  awful.tag.viewnext       ),
  awful.key({ modkey,               }, "Escape", awful.tag.history.restore),
  
  -- awful.key({ altkey,           }, "Tab", function ()  awful.client.focus.byidx( 1) end),
  -- awful.key({ altkey, "Shift"           }, "Tab", function () awful.client.focus.byidx(-1) end),

  awful.key({ altkey,           }, "Tab",
    function ()
      awful.client.focus.byidx( 1)
      if client.focus then client.focus:raise() end
  end),
  awful.key({ altkey,    "Shift"    }, "Tab",
    function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
  end),
  awful.key({ }, "Print", function () awful.util.spawn("upload_screens scr") end),

  -- Layout manipulation
  awful.key({ modkey,           }, "Tab", function () awful.client.swap.byidx(  1)    end),
  awful.key({ modkey, "Shift"   }, "Tab", function () awful.client.swap.byidx( -1)    end),
  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
  -- not very useful
--  awful.key({ modkey,           }, "Tab",
--    function ()
--      awful.client.focus.history.previous()
--      if client.focus then
--        client.focus:raise()
--      end
--  end),

  -- Standard program
  awful.key({ modkey,           }, "i",      function () awful.tag.incmwfact( 0.05)    end),
  awful.key({ modkey,           }, "d",      function () awful.tag.incmwfact(-0.05)    end),
  awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)      end),
  awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1)      end),
  awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1)         end),
  awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1)         end),
  -- awful.key({ modkey, "Control" }, "space",  function () awful.layout.inc(layouts, -1) end),
  awful.key({ modkey            }, "space",  function () awful.layout.inc(layouts, -1) end),
  awful.key({ 0,                }, "XF86HomePage",    function () awful.util.spawn(browser)     end),
  awful.key({ 0,                }, "XF86Mail",        function () awful.util.spawn(mail)        end),
  awful.key({ 0,                }, "XF86Calculator",  function () awful.util.spawn(calculator)  end),
  awful.key({ 0,                }, "XF86AudioRaiseVolume",  function () awful.util.spawn(volumeup)    end),
  awful.key({ 0,                }, "XF86AudioLowerVolume",  function () awful.util.spawn(volumedown)  end),
  awful.key({ 0,                }, "XF86AudioMute",         function () awful.util.spawn(volumemute)  end),
  awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal)    end),
  awful.key({ altkey            }, "F1",     function () awful.util.spawn(terminal)    end),
  awful.key({ modkey, "Control" }, "l",      function () awful.util.spawn(txteditor)   end),
  awful.key({ modkey, "Control" }, "g",      function () awful.util.spawn(art)         end),
  awful.key({ modkey, "Control" }, "o",      function () awful.util.spawn(writer)      end),
  awful.key({ modkey, "Control" }, "p",      function () awful.util.spawn(ssheet)      end),
  awful.key({ 0,                }, "Menu",   function () awful.util.spawn(filemgr)     end),
  awful.key({ altkey,           }, "F2",     function () awful.util.spawn(rmenu)       end),
  -- awful.key({ modkey,           }, "x",      function () awful.util.spawn(guimenu)      end),
  -- awful.key({ modkey            }, "space",  function () awful.util.spawn(rmenu)       end),
  awful.key({ modkey, "Shift"   }, "q",      function () awful.util.spawn(rexit)       end),
  awful.key({ modkey,           }, "q",      awesome.restart),
  awful.key({ modkey, "Shift"   }, "e",      awesome.quit),
  awful.key({ modkey, "Control" }, "n",      awful.client.restore),
  -- Menubar
  awful.key({ modkey            }, "b",      function() menubar.show() end)
)

clientkeys = awful.util.table.join(
  awful.key({ modkey, "Shift"   }, "f",      function (c) c.fullscreen = not c.fullscreen   end),
  awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                          end),
  awful.key({ altkey,           }, "F4",      function (c) c:kill()                         end),
  awful.key({ modkey, "Shift"   }, "space",  awful.client.floating.toggle                      ),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster())  end),
  awful.key({ modkey,           }, "o",      awful.client.movetoscreen                         ),
  awful.key({ modkey, "Shift"   }, "t",      function (c) c.ontop = not c.ontop             end),
  awful.key({ modkey,           }, "n",
    function (c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
  end),

  -- not really used
--  awful.key({ modkey,           }, "m",
--    function (c)
--      c.maximized_horizontal = not c.maximized_horizontal
--      c.maximized_vertical   = not c.maximized_vertical
--  end),

-- standard maximize binding
  awful.key({ altkey,           }, "F10", function (c) c.maximized = not c.maximized c:raise() end)

-- do net edit below this line
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
  keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
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
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
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
                  {description = "move focused client to tag #"..i, group = "tag"}),
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
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ altkey }, 1, awful.mouse.client.move),
    awful.button({ altkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = { border_width = beautiful.border_width,
                   border_color = beautiful.border_normal,
                   focus = awful.client.focus.filter,
                   size_hints_honor = false,
                   keys = clientkeys,
                   buttons = clientbuttons } },
  { rule = { class = "mpv" },
    properties = { floating = true } },
  { rule = { class = "pinentry" },
    properties = { floating = true } },
  { rule = { class = "Gimp" },
    properties = { tag = tags[1][3] } },
--    properties = { floating = true } },
  { rule = { class = "Thunderbird" },
    properties = { tag = tags[1][2] } },
--  { rule = { class = "VirtualBox" },
--    properties = { tag = tags[1][5] } },
--  { rule = { class = "Gns3" },
--    properties = { tag = tags[1][5] } },
  -- Set Firefox to always map on tags number 2 of screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { tag = tags[1][2] } },

{ rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Exit_Session",
          "XCalc",
          "Galculator",
          "SThermal",
          "PCalendar",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "Yad"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
                        -- Enable sloppy focus
                        c:connect_signal("mouse::enter", function(c)
                                           if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                                           and awful.client.focus.filter(c) then
                                             client.focus = c
                                           end
                        end)

                        if not startup then
                          -- Set the windows at the slave,
                          -- i.e. put it at the end of others instead of setting it master.
                          -- awful.client.setslave(c)

                          -- Put windows in a smart way, only if they does not set an initial position.
                          if not c.size_hints.user_position and not c.size_hints.program_position then
                            awful.placement.no_overlap(c)
                            awful.placement.no_offscreen(c)
                          end
                        end

                        local titlebars_enabled = false
                        if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
                          -- Widgets that are aligned to the left
                          local left_layout = wibox.layout.fixed.horizontal()
                          left_layout:add(awful.titlebar.widget.iconwidget(c))

                          -- Widgets that are aligned to the right
                          local right_layout = wibox.layout.fixed.horizontal()
                          right_layout:add(awful.titlebar.widget.floatingbutton(c))
                          right_layout:add(awful.titlebar.widget.maximizedbutton(c))
                          right_layout:add(awful.titlebar.widget.stickybutton(c))
                          right_layout:add(awful.titlebar.widget.ontopbutton(c))
                          right_layout:add(awful.titlebar.widget.closebutton(c))

                          -- The title goes in the middle
                          local title = awful.titlebar.widget.titlewidget(c)
                          title:buttons(awful.util.table.join(
                                          awful.button({ }, 1, function()
                                              client.focus = c
                                              c:raise()
                                              awful.mouse.client.move(c)
                                          end),
                                          awful.button({ }, 3, function()
                                              client.focus = c
                                              c:raise()
                                              awful.mouse.client.resize(c)
                                          end)
                          ))

                          -- Now bring it all together
                          local layout = wibox.layout.align.horizontal()
                          layout:set_left(left_layout)
                          layout:set_right(right_layout)
                          layout:set_middle(title)

                          awful.titlebar(c):set_widget(layout)
                        end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
