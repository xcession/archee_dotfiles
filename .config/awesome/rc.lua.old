-- awesome 3.1 configuration file by xcession
-- last update: 21/12/08

--------------------------------------------------------------------------------
--{{{ Imports

-- Load default libraries
require("awful")
require("beautiful")
-- Naughty is a notification library (like gnome-notifications)
require("naughty")

--}}}
--------------------------------------------------------------------------------
--{{{ Theme!

beautiful.init(awful.util.getdir("config") .. "/theme")

beautiful.taglist_squares_sel       = awful.util.getdir("config") .. "/taglist/squarefw.png"
beautiful.taglist_squares_unsel     = awful.util.getdir("config") .. "/taglist/squarew.png"
beautiful.tasklist_floating_icon    = awful.util.getdir("config") .. "/tasklist/floatingw.png"
beautiful.awesome_icon              = awful.util.getdir("config") .. "/icons/awesome16.png"

beautiful.menu_submenu_icon         = awful.util.getdir("config") .. "/icons/submenu.png"

use_titlebar = false

--}}}
-------------------------------------------------------------------------------------
--{{{ Load functions

loadfile(awful.util.getdir("config") .. "/functions.lua")()

--}}}
--------------------------------------------------------------------------------
--{{{ Variables

-- Default modkey
modkey = "Mod4"

-- This is used later as the default terminal and editor to run
terminal = "urxvt"

-- The layouts
layouts =
{
    "tile",
    "tileleft",
    -- "tilebottom",
    -- "tiletop",
    -- "fairh",
    -- "fairv",
    -- "magnifier",
    "max",
    "fullscreen",
    -- "spiral",
    -- "dwindle",
    "floating"
}

defaultLayout = layouts[3]

-- Apps that should be forced floating
floatapps =
{
    -- by class
    ["MPlayer"]     = true,
    ["Gimp"]        = true,
    -- by instance
    ["mocp"]        = true
}

-- App tags
apptags =
{
    -- ["Firefox"]  = { screen = 1, tag = 2 },
    -- ["mocp"]     = { screen = 2, tag = 4 },
}

--}}}
--------------------------------------------------------------------------------
--{{{ Menu
-- Popup menu when we rightclick the desktop

-- Submenu
awesomemenu = {
    { "restart", awesome.restart },
    { "quit", awesome.quit }
}
-- Main menu
mainmenu = awful.menu.new({
    items = {
        { "awesome", awesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal }
    }
})

--}}}
--------------------------------------------------------------------------------
-- {{{ Tags

tags = {}
for s = 1, screen.count() do
    tags[s] = {}
    -- Give the first 3 tag special names
    tags[s][1] = tag({ name = "1-term", layout = defaultLayout })
    tags[s][2] = tag({ name = "2-web", layout = defaultLayout })
    -- Put them on the screen
    for tagnumber = 1, 2 do
        tags[s][tagnumber].screen = s
    end
    -- Automatically name the next 6 tags after their tag number and put them on the screen
    for tagnumber = 3, 6 do
        tags[s][tagnumber] = tag({ name = tagnumber, layout = defaultLayout })
        tags[s][tagnumber].screen = s
    end
    -- Select at least one tag
    tags[s][1].selected = true
end

-- }}}
-------------------------------------------------------------------------------------
--{{{ Widgets

-- Separator icon
separator = widget({ type = "imagebox", align = "right" })
separator.image = image(awful.util.getdir("config") .. "/icons/separator.png")

-- Create a systray
systray = widget({ type = "systray", align = "right" })

-- Create a clock widget
clockwidget = widget({ type = "textbox", align = "right" })

-- Create a battery widget
batteryicon = widget({ type = "imagebox", align = "right" })
batteryicon.image = image(awful.util.getdir("config") .. "/icons/batteryw.png")
batterywidget = widget({ type = "textbox", align = "right" })
batteryInfo("BAT0")

-- Create a wibox for each screen and add it
statusbar = {}
promptbox = {}
layouticon = {}
taglist = {}
-- Initialize which buttons do what when clicking the taglist
taglist.buttons =   {
                        button({ }, 1, awful.tag.viewonly),
                        button({ modkey }, 1, awful.client.movetotag),
                        button({ }, 3, function (tag) tag.selected = not tag.selected end),
                        button({ modkey }, 3, awful.client.toggletag),
                        button({ }, 4, awful.tag.viewnext),
                        button({ }, 5, awful.tag.viewprev)
                    }

tasklist = {}
-- Initialize which buttons do what when clicking the tasklist
tasklist.buttons = {
                        button({ }, 1, function (c) client.focus = c; c:raise() end),
                        button({ }, 3, function () awful.menu.clients({ width=250 }) end),
                        button({ }, 4, function () awful.client.focus.byidx(1) end),
                        button({ }, 5, function () awful.client.focus.byidx(-1) end)
                     }

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    promptbox[s] = widget({ type = "textbox", align = "left" })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    layouticon[s] = widget({ type = "imagebox", align = "right" })
    layouticon[s]:buttons({ button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 5, function () awful.layout.inc(layouts, -1) end) })
    -- Create a taglist widget
    taglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, taglist.buttons)

    -- Create a tasklist widget
    tasklist[s] = awful.widget.tasklist.new(function(c)
                                                  return awful.widget.tasklist.label.currenttags(c, s)
                                              end, tasklist.buttons)

    -- Create the wibox
    statusbar[s] = wibox({
        position = "top",
        height = "16",
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal
    })
    -- Add widgets to the wibox - order matters
    statusbar[s].widgets = {
                                taglist[s],
                                layouticon[s],
                                tasklist[s],
                                promptbox[s],
                                separator,
                                batteryicon,
                                batterywidget,
                                separator,
                                clockwidget,
                                s == 1 and systray or nil
                            }
    statusbar[s].screen = s
end

--}}}
--------------------------------------------------------------------------------
--{{{ Bindings

-- {{{ Mouse bindings
awesome.buttons({
    button({ }, 3, function () mainmenu:toggle() end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}

-- {{{ Key bindings

-- Bind keyboard digits
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    keybinding({ modkey }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end):add()
    keybinding({ modkey, "Control" }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           tags[screen][i].selected = not tags[screen][i].selected
                       end
                   end):add()
    keybinding({ modkey, "Shift" }, i,
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.movetotag(tags[client.focus.screen][i])
                           end
                       end
                   end):add()
    keybinding({ modkey, "Control", "Shift" }, i,
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.toggletag(tags[client.focus.screen][i])
                           end
                       end
                   end):add()
end

keybinding({ modkey }, "Left", awful.tag.viewprev):add()
keybinding({ modkey }, "Right", awful.tag.viewnext):add()
keybinding({ modkey }, "Escape", awful.tag.history.restore):add()

-- Standard program
keybinding({ modkey }, "Return", function () awful.util.spawn(terminal) end):add()

keybinding({ modkey, "Control" }, "r", function ()
                                           promptbox[mouse.screen].text =
                                               awful.util.escape(awful.util.restart())
                                        end):add()
keybinding({ modkey, "Shift" }, "q", awesome.quit):add()

-- Client manipulation
keybinding({ modkey }, "m", awful.client.maximize):add()
keybinding({ modkey }, "f", function () if client.focus then client.focus.fullscreen = not client.focus.fullscreen end end):add()
keybinding({ modkey, "Shift" }, "c", function () if client.focus then client.focus:kill() end end):add()
keybinding({ modkey }, "j", function () awful.client.focus.byidx(1); if client.focus then client.focus:raise() end end):add()
keybinding({ modkey }, "k", function () awful.client.focus.byidx(-1);  if client.focus then client.focus:raise() end end):add()
keybinding({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1) end):add()
keybinding({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end):add()
keybinding({ modkey, "Control" }, "j", function () awful.screen.focus(1) end):add()
keybinding({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end):add()
keybinding({ modkey, "Control" }, "space", awful.client.togglefloating):add()
keybinding({ modkey, "Control" }, "Return", function () if client.focus then client.focus:swap(awful.client.getmaster()) end end):add()
keybinding({ modkey }, "o", awful.client.movetoscreen):add()
keybinding({ modkey }, "Tab", awful.client.focus.history.previous):add()
keybinding({ modkey }, "u", awful.client.urgent.jumpto):add()
keybinding({ modkey, "Shift" }, "r", function () if client.focus then client.focus:redraw() end end):add()

-- Layout manipulation
keybinding({ modkey }, "l", function () awful.tag.incmwfact(0.05) end):add()
keybinding({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end):add()
keybinding({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end):add()
keybinding({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end):add()
keybinding({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end):add()
keybinding({ modkey }, "space", function () awful.layout.inc(layouts, 1) end):add()
keybinding({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end):add()

-- Prompt
keybinding({ modkey }, "F1", function ()
                                 awful.prompt.run({ prompt = "Run: " }, promptbox[mouse.screen], awful.util.spawn, awful.completion.bash,
                                                  awful.util.getdir("cache") .. "/history")
                             end):add()
keybinding({ modkey }, "F4", function ()
                                 awful.prompt.run({ prompt = "Run Lua code: " }, promptbox[mouse.screen], awful.util.eval, awful.prompt.bash,
                                                  awful.util.getdir("cache") .. "/history_eval")
                             end):add()

keybinding({ modkey, "Ctrl" }, "i", function ()
                                        local s = mouse.screen
                                        if promptbox[s].text then
                                            promptbox[s].text = nil
                                        elseif client.focus then
                                            promptbox[s].text = nil
                                            if client.focus.class then
                                                promptbox[s].text = "Class: " .. client.focus.class .. " "
                                            end
                                            if client.focus.instance then
                                                promptbox[s].text = promptbox[s].text .. "Instance: ".. client.focus.instance .. " "
                                            end
                                            if client.focus.role then
                                                promptbox[s].text = promptbox[s].text .. "Role: ".. client.focus.role
                                            end
                                        end
                                    end):add()

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
keybinding({ modkey }, "t", awful.client.togglemarked):add()

for i = 1, keynumber do
    keybinding({ modkey, "Shift" }, "F" .. i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           for k, c in pairs(awful.client.getmarked()) do
                               awful.client.movetotag(tags[screen][i], c)
                           end
                       end
                   end):add()
end

--}}}
--------------------------------------------------------------------------------
--{{{ Hooks

-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Hook function to execute when unmarking a client.
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Hook function to execute when the mouse enters a client.
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= "magnifier"
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c)
    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, function (c) c:mouse_move() end),
        button({ modkey }, 3, function (c) c:mouse_resize() end)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        c.floating = floatapps[cls]
    elseif floatapps[inst] then
        c.floating = floatapps[inst]
    end

    -- Check application->screen/tag mappings.
    local target
    if apptags[cls] then
        target = apptags[cls]
    elseif apptags[inst] then
        target = apptags[inst]
    end
    if target then
        c.screen = target.screen
        awful.client.movetotag(tags[target.screen][target.tag], c)
    end

    -- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
    client.focus = c

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    -- c.honorsizehints = false
end)

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.get(screen)
    if layout then
        layouticon[screen].image = image(awful.util.getdir("config") .. "/icons/layouts/" .. awful.layout.get(screen) .. "w.png")
    else
        layouticon[screen].image = nil
    end

    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end

    -- Uncomment if you want mouse warping
    --[[
    if client.focus then
        local c_c = client.focus:fullgeometry()
        local m_c = mouse.coords()

        if m_c.x < c_c.x or m_c.x >= c_c.x + c_c.width or
            m_c.y < c_c.y or m_c.y >= c_c.y + c_c.height then
            if table.maxn(m_c.buttons) == 0 then
                mouse.coords({ x = c_c.x + 5, y = c_c.y + 5})
            end
        end
    end
    ]]
end)

-- Timed hooks for the widget functions
-- 1 second
awful.hooks.timer.register(1, function ()
    clockwidget.text = " " .. os.date() .. " "
end)

-- 20 seconds
awful.hooks.timer.register(20, function ()
    batteryInfo("BAT0")
end)

-- }}}
