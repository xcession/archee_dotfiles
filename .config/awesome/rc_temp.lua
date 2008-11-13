--[[ awesome 3 configuration file by xcession
     only works with awesome-git newer than 20/10/08
     last update: 13/11/08                          ]]

--------------------------------------------------------------------------------
--{{{ Imports

-- Load default libraries
require("awful")
require("beautiful")

--}}}
--------------------------------------------------------------------------------
--{{{ Variables

terminal = "urxvt"

modkey = "Mod4"

-- The layouts
layouts     = { "tile"
              , "tileleft"
              --, "tilebottom"
              --, "tiletop"
              --, "fairh"
              --, "fairv"
              --, "magnifier"
              , "max"
              , "floating"
              }

defaultLayout = layouts[3]

-- Apps that should be forced floating
floatapps =
{
    -- by class
    ["MPlayer"]     = true,
    ["Gimp"]        = true,
    ["Mirage"]      = true,
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
--{{{ Theme!

theme_name = "xcession"

use_titlebar = false

--}}}
--------------------------------------------------------------------------------
--{{{ Register theme (don't change this)

beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name)
awful.beautiful.register(beautiful)

--}}}
--------------------------------------------------------------------------------
--{{{ Tags

tags = {}
for s = 1, screen.count() do
    tags[s] = {}
    -- Give the first 3 tag special names
    tags[s][1] = tag({ name = "1-term", layout = defaultLayout })
    tags[s][2] = tag({ name = "2-web", layout = defaultLayout })
    tags[s][3] = tag({ name = "3-dev", layout = defaultLayout })
    -- Put them on the screen
    for tagnumber = 1, 3 do
        tags[s][tagnumber].screen = s
    end
    -- Automatically name the next 6 tags after their tag number and put them on the screen
    for tagnumber = 4, 6 do
        tags[s][tagnumber] = tag({ name = tagnumber, layout = defaultLayout })
        tags[s][tagnumber].screen = s
    end
    -- Select at least one tag
    tags[s][1].selected = true
end
-- }}}

--}}}
--------------------------------------------------------------------------------
--{{{ Widgets

-- Create a taglist widget
taglist = widget({ type = "taglist", name = "taglist" })
taglist:mouse_add(mouse({}, 1, function (object, tag) awful.tag.viewonly(tag) end))
taglist:mouse_add(mouse({ modkey }, 1, function (object, tag) awful.client.movetotag(tag) end))
taglist:mouse_add(mouse({}, 3, function (object, tag) tag.selected = not tag.selected end))
taglist:mouse_add(mouse({ modkey }, 3, function (object, tag) awful.client.toggletag(tag) end))
taglist:mouse_add(mouse({ }, 4, awful.tag.viewnext))
taglist:mouse_add(mouse({ }, 5, awful.tag.viewprev))
taglist.label = awful.widget.taglist.label.all

-- Create a tasklist widget
tasklist = widget({ type = "tasklist", name = "tasklist" })
tasklist:mouse_add(mouse({ }, 1, function (object, c) client.focus = c; c:raise() end))
tasklist:mouse_add(mouse({ }, 4, function () awful.client.focusbyidx(1) end))
tasklist:mouse_add(mouse({ }, 5, function () awful.client.focusbyidx(-1) end))
tasklist.label = awful.widget.tasklist.label.currenttags

-- Create a textbox widget
promptbox = widget({ type = "textbox", name = "promptbox", align = "left" })
datetime = widget({ type = "textbox", name = "datetime", align = "right" })
battery = widget({ type = "textbox", name = "battery", align = "right" })
-- Set the default text in textbox
-- mytextbox.text = "<b><small> awesome " .. AWESOME_VERSION .. " </small></b>"

-- Create an iconbox widget
-- myiconbox = widget({ type = "textbox", name = "myiconbox", align = "left" })
-- myiconbox.text = "<bg image=\"/usr/share/awesome/icons/awesome16.png\" resize=\"true\"/>"

-- Create a systray
systray = widget({ type = "systray", name = "systray", align = "right" })

-- Create an iconbox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
layoutbox = {}
for s = 1, screen.count() do
    layoutbox[s] = widget({ type = "textbox", name = "layoutbox", align = "right" })
    layoutbox[s]:mouse_add(mouse({ }, 1, function () awful.layout.inc(layouts, 1) end))
    layoutbox[s]:mouse_add(mouse({ }, 3, function () awful.layout.inc(layouts, -1) end))
    layoutbox[s]:mouse_add(mouse({ }, 4, function () awful.layout.inc(layouts, 1) end))
    layoutbox[s]:mouse_add(mouse({ }, 5, function () awful.layout.inc(layouts, -1) end))
    --layoutbox[s].text = "<bg image=\"/usr/share/awesome/icons/layouts/tilew.png\" resize=\"true\"/>"
end

-- Create a statusbar for each screen and add it
statbar = {}
for s = 1, screen.count() do
    statbar[s] = statusbar({ position = "top", name = "statbar" .. s,
                                 fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the statusbar - order matters
    statbar[s]:widgets({
        taglist,
        tasklist,
        --myiconbox,
        promptbox,
        datetime,
        battery,
        layoutbox[s],
        s == 1 and systray or nil
    })
    statbar[s].screen = s
end

--}}}
--------------------------------------------------------------------------------
--{{{ Bindings

-- {{{ Mouse bindings
awesome.mouse_add(mouse({ }, 3, function () awful.spawn(terminal) end))
awesome.mouse_add(mouse({ }, 4, awful.tag.viewnext))
awesome.mouse_add(mouse({ }, 5, awful.tag.viewprev))
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
                       local sel = client.focus
                       if sel then
                           if tags[sel.screen][i] then
                               awful.client.movetotag(tags[sel.screen][i])
                           end
                       end
                   end):add()
    keybinding({ modkey, "Control", "Shift" }, i,
                   function ()
                       local sel = client.focus
                       if sel then
                           if tags[sel.screen][i] then
                               awful.client.toggletag(tags[sel.screen][i])
                           end
                       end
                   end):add()
end

keybinding({ modkey },              "Left",     awful.tag.viewprev):add()
keybinding({ modkey },              "Right",    awful.tag.viewnext):add()
keybinding({ modkey },              "Escape",   awful.tag.history.restore):add()

-- Standard program
keybinding({ modkey },              "Return",   function () awful.spawn(terminal) end):add()

keybinding({ modkey, "Control" },   "r",        awesome.restart):add()
keybinding({ modkey, "Shift" },     "q",        awesome.quit):add()

-- Client manipulation
keybinding({ modkey },              "m",        awful.client.maximize):add()
keybinding({ modkey, "Shift" },     "c",        function () client.focus:kill() end):add()
keybinding({ modkey },              "j",        function () awful.client.focusbyidx(1); client.focus:raise() end):add()
keybinding({ modkey },              "k",        function () awful.client.focusbyidx(-1);  client.focus:raise() end):add()
keybinding({ modkey, "Shift" },     "j",        function () awful.client.swap(1) end):add()
keybinding({ modkey, "Shift" },     "k",        function () awful.client.swap(-1) end):add()
keybinding({ modkey, "Control" },   "j",        function () awful.screen.focus(1) end):add()
keybinding({ modkey, "Control" },   "k",        function () awful.screen.focus(-1) end):add()
keybinding({ modkey, "Control" },   "space",    awful.client.togglefloating):add()
keybinding({ modkey, "Control" },   "Return",   function () client.focus:swap(awful.client.master()) end):add()
keybinding({ modkey },              "o",        awful.client.movetoscreen):add()
keybinding({ modkey },              "Tab",      awful.client.focus.history.previous):add()
keybinding({ modkey },              "u",        awful.client.urgent.jumpto):add()
keybinding({ modkey, "Shift" },     "r",        function () client.focus:redraw() end):add()

-- Layout manipulation
keybinding({ modkey },              "l",        function () awful.tag.incmwfact(0.05) end):add()
keybinding({ modkey },              "h",        function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ modkey, "Shift" },     "h",        function () awful.tag.incnmaster(1) end):add()
keybinding({ modkey, "Shift" },     "l",        function () awful.tag.incnmaster(-1) end):add()
keybinding({ modkey, "Control" },   "h",        function () awful.tag.incncol(1) end):add()
keybinding({ modkey, "Control" },   "l",        function () awful.tag.incncol(-1) end):add()
keybinding({ modkey },              "space",    function () awful.layout.inc(layouts, 1) end):add()
keybinding({ modkey, "Shift" },     "space",    function () awful.layout.inc(layouts, -1) end):add()

-- Prompt
keybinding({ modkey }, "F1", function ()
                                 awful.prompt.run({ prompt = "Run: " }, promptbox, awful.spawn, awful.completion.bash,
os.getenv("HOME") .. "/.cache/awesome/history") end):add()
keybinding({ modkey }, "F4", function ()
                                 awful.prompt.run({ prompt = "Run Lua code: " }, promptbox, awful.eval, awful.prompt.bash,
os.getenv("HOME") .. "/.cache/awesome/history_eval") end):add()
keybinding({ modkey, "Ctrl" }, "i", function ()
                                        if promptbox.text then
                                            promptbox.text = nil
                                        else
                                            promptbox.text = nil
                                            if client.focus.class then
                                                promptbox.text = "Class: " .. client.focus.class .. " "
                                            end
                                            if client.focus.instance then
                                                promptbox.text = promptbox.text .. "Instance: ".. client.focus.instance .. " "
                                            end
                                            if client.focus.role then
                                                promptbox.text = promptbox.text .. "Role: ".. client.focus.role
                                            end
                                        end
                                    end):add()

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
function hook_focus(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end

-- Hook function to execute when unfocusing a client.
function hook_unfocus(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end

-- Hook function to execute when marking a client
function hook_marked(c)
    c.border_color = beautiful.border_marked
end

-- Hook function to execute when unmarking a client
function hook_unmarked(c)
    c.border_color = beautiful.border_focus
end

-- Hook function to execute when the mouse is over a client.
function hook_mouseover(c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= "magnifier" then
        client.focus = c
    end
end

-- Hook function to execute when a new client appears.
function hook_manage(c)
    -- Set floating placement to be smart!
    c.floating_placement = "smart"
    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:mouse_add(mouse({ }, 1, function (c) client.focus = c; c:raise() end))
    c:mouse_add(mouse({ modkey }, 1, function (c) c:mouse_move() end))
    c:mouse_add(mouse({ modkey }, 3, function (c) c:mouse_resize() end))
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal
    client.focus = c

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

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- awful.client.setslave(c)

    -- Honor size hints
    c.honorsizehints = true
end

-- Hook function to execute when arranging the screen
-- (tag switch, new client, etc)
function hook_arrange(screen)
    local layout = awful.layout.get(screen)
    if layout then
        layoutbox[screen].text =
            --"<bg image=\"/usr/share/awesome/icons/layouts/" .. awful.layout.get(screen) .. "w.png\" resize=\"true\"/>"
            "<bg image=\"/home/xcession/.config/awesome/icons/layouts/" .. awful.layout.get(screen) .. "w.png\" resize=\"true\"/>"
        else
            layoutbox[screen].text = "No layout."
    end

    -- If no window has focus, give focus to the latest in history
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end

function get_command_output (command)
    local c = io.popen(command)
    local output = {}
    i = 0
    return c:read("*line")
end

-- Hook called every second
function hook_timer ()
    -- For unix time_t lovers
    -- mytextbox.text = " " .. os.time() .. " time_t "
    -- Otherwise use:
    datetime.text = " " .. os.date() .. " "
    battery.text = " " .. get_command_output("battery") .. " "

end

-- Set up some hooks
awful.hooks.focus.register(hook_focus)
awful.hooks.unfocus.register(hook_unfocus)
awful.hooks.marked.register(hook_marked)
awful.hooks.unmarked.register(hook_unmarked)
awful.hooks.manage.register(hook_manage)
awful.hooks.mouseover.register(hook_mouseover)
awful.hooks.arrange.register(hook_arrange)
awful.hooks.timer.register(1, hook_timer)
-- }}}
