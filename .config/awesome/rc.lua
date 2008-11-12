--[[ awesome 3 configuration file by xcession
     only works with awesome-gt newer than 13/10/08
     last update: 13/10/08                          ]]

--------------------------------------------------------------------------------
--{{{ Imports

-- Load default libraries
require("awful")
require("beautiful")

--}}}
--------------------------------------------------------------------------------
--{{{ Initialize some stuff

tags        = {}
statusbar   = {}
promptbox   = {}
layouticon  = {}
taglist     = {}
tasklist    = {}

--}}}
--------------------------------------------------------------------------------
--{{{ Variables

modMask = "Mod4"

-- Default apps
term            = "urxvtc" or "urxvt"
browser         = "/usr/bin/firefox"
-- fileManager     = "thunar"

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

-- Text for the current layout
layoutText  = { ["tile"]        = "Tiled"
              , ["tileleft"]    = "TileLeft"
              , ["tilebottom"]  = "TileBottom"
              , ["tiletop"]     = "TileTop"
              , ["fairh"]       = "FairH"
              , ["fairv"]       = "FairV"
              , ["magnifier"]   = "Magnifier"
              , ["max"]         = "Max"
              , ["floating"]    = "Floating"
              }

defaultLayout = layouts[3]

-- Apps that should be forced floating
floatapps   = { ["MPlayer"]   = true
              , ["Gimp"]    = true
              , ["Mirage"]  = true
              , ["mocp"]    = true
}

-- App tags
apptags =
{
    -- ["Firefox"] = { screen = 1, tag = 2 },
    -- ["mocp"] = { screen = 2, tag = 4 },
}

--}}}
--------------------------------------------------------------------------------
--{{{ Theme!

--theme_path = "/themes/xcession"

beautiful.font                      = "Terminus 8"

beautiful.bg_normal                 = "#000000AA"
beautiful.fg_normal                 = "#C4C4C4"

beautiful.bg_focus                  = "#1C1C1CAA"
beautiful.fg_focus                  = "#3579A8"

beautiful.bg_urgent                 = "#3579A8AA"
beautiful.fg_urgent                 = "#EFEFEF"

beautiful.border_width              = "1"
beautiful.border_normal             = "#4C4C4C66"
beautiful.border_focus              = "#3579A866"
beautiful.border_marked             = "#FF000066"

beautiful.taglist_squares_sel       = "/usr/share/awesome/themes/default/taglist/squarefw.png"
beautiful.taglist_squares_unsel     = "/usr/share/awesome/themes/default/taglist/squarew.png"
beautiful.tasklist_floating_icon    = "/usr/share/awesome/themes/default/tasklist/floatingw.png"
beautiful.awesome_icon              = "/usr/share/awesome/icons/awesome16.png"

beautiful.menu_submenu_icon         = awful.util.getdir("config").."/icons/submenu.png"
beautiful.menu_height               = "16"
beautiful.menu_width                = "100"

beautiful.taglist_squares           = true
beautiful.titlebar_close_button     = true

--}}}
--------------------------------------------------------------------------------
--{{{ Register theme (don't change this)

awful.beautiful.register(beautiful)
awesome.font(beautiful.font)

--}}}
--------------------------------------------------------------------------------
--{{{ Load functions

loadfile(awful.util.getdir("config").."/functions.lua")()

--}}}
--------------------------------------------------------------------------------
--{{{ Menu
-- Popup menu when we rightclick the desktop

-- Submenu
awesomemenu         = { { "Edit config" , term.." -e vim "..awful.util.getdir("config").."/rc.lua" }
                      , { "Restart"     , awesome.restart }
                      , { "Quit"        , awesome.quit }
                      }
-- Main menu
mainmenu            = awful.menu.new({ items = { { "Terminal"    , term }
                                               , { "Firefox"     , browser }
                                               --, { "Thunar"      , fileManager }
                                               , { "Gvim"        , "gvim" }
                                               , { "Gimp"        , "gimp" }
                                               , { "Screen"      , term.." -e screen -RR" }
                                               --, { "Ncmpcpp"     , term.." -e ncmpcpp" }
                                               , { "Awesome"     , awesomemenu }
                                               }
                                     })

--}}}
--------------------------------------------------------------------------------
--{{{ Tags

for s = 1, screen.count() do
    tags[s] = {}
    -- Give the first 3 tag special names
    tags[s][1] = tag({ name = "1-term", layout = layouts[1], mwfact = 0.618033988769 })
    tags[s][2] = tag({ name = "2-web", layout = layouts[1] })
    tags[s][3] = tag({ name = "3-dev", layout = layouts[4], mwfact = 0.15 })
    -- Put them on the screen
    for tagnumber = 1, 3 do
        tags[s][tagnumber].screen = s
    end
    -- Automatically name the next 6 tags after their tag number and put them on the screen
    for tagnumber = 4, 9 do
        tags[s][tagnumber] = tag({ name = tagnumber, layout = layouts[1] })
        tags[s][tagnumber].screen = s
    end
    -- Select at least one tag
    tags[s][1].selected = true
end

--}}}
--------------------------------------------------------------------------------
--{{{ Widgets
-- Please note the functions feeding some of the widgets are found in functions.lua

-- Simple spacer we can use to cleaner code
spacer = " "
-- Separator icon
separator = widget({ type = "imagebox", name = "separator", align = "right" })
separator.image = image(awful.util.getdir("config").."/icons/separators/link2.png")

-- Create the clock widget
clockwidget = widget({ type = "textbox", name = "clockwidget", align = "right" })
-- Run it once so we don't have to wait for the hooks to see our clock
clockInfo("%d/%m/%Y", "%T")

-- Create the wifi widget
wifiwidget = widget({ type = "textbox", name = "wifiwidget", align = "right" })
-- Run it once so we don't have to wait for the hooks to see our signal strength
wifiInfo("wlan0")

-- Create the battery widget
batterywidget = widget({ type = "textbox", name = "batterywidget", align = "right" })
-- Run it once so we don't have to wait for the hooks to see our percentage
batteryInfo("BAT1")

-- Create the memory widget
memwidget = widget({ type = "textbox", name = "memwidget", align = "right" })
-- Run it once so we don't have to wait for the hooks to see our memory usage
memInfo()

-- Create the gmail widget
gmailwidget = widget({ type = "textbox", name = "gmailwidget", align = "right" })
-- Run it once so we don't have to wait for the hooks to see our mails
gmailInfo("/tmp/gmail-temp")

-- Create a system tray
systray = widget({ type = "systray", name = "systray", align = "right" })

-- Initialize which buttons do what when clicking the taglist
taglist.buttons     = { button({ }          , 1, awful.tag.viewonly)
                      , button({ modMask }  , 1, awful.client.movetotag)
                      , button({ }          , 3, function (tag) tag.selected = not tag.selected end)
                      , button({ modMask }  , 3, awful.client.toggletag)
                      , button({ }          , 4, awful.tag.viewnext)
                      , button({ }          , 5, awful.tag.viewprev) 
                      }
-- Initialize which buttons do what when clicking the tasklist
tasklist.buttons    = { button({ }          , 1, function (c) client.focus = c; c:raise() end)
                      , button({ }          , 4, function () awful.client.focus.byidx(1) end)
                      , button({ }          , 5, function () awful.client.focus.byidx(-1) end) 
                      }

-- From here on, everything gets created for every screen
for s = 1, screen.count() do
    -- Promptbox (pops up with mod+r)
    promptbox[s] = widget({ type = "textbox", name = "promptbox"..s, align = "left" })
    -- Layout icon, which is actually the layouttext which we defined before
    layouticon[s] = widget({ type = "textbox", name = "layouticon" })
    -- Which buttons do what when clicking the layout text
    layouticon[s].buttons = { button({ }      , 1, function () awful.layout.inc(layouts, 1) end)
                            , button({ }      , 3, function () awful.layout.inc(layouts, -1) end)
                            , button({ }      , 4, function () awful.layout.inc(layouts, 1) end)
                            , button({ }      , 5, function () awful.layout.inc(layouts, -1) end) 
                            }
    -- Create the taglist
    taglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, taglist.buttons)
    -- Create the tasklist
    tasklist[s] = awful.widget.tasklist.new(function(c)
                                                if c == client.focus then 
                                                    return spacer..c.name..spacer
                                                end
                                            end, tasklist.buttons)
 
    -- Finally, create the statusbar (called wibox), and set its properties
    statusbar[s] = wibox({
        position = "top", 
        height = "16", 
        name = "statusbar"..s, 
        fg = beautiful.fg_normal, 
        bg = beautiful.bg_normal, 
        border_color = beautiful.border_normal, 
        border_width = beautiful.border_width 
    })
    -- Add our widgets to the wibox
    statusbar[s].widgets = { taglist[s]
                           , layouticon[s]
                           , tasklist[s]
                           , promptbox[s]
                           , separator
                           , memwidget
                           , separator
                           , wifiwidget
                           , separator
                           , batterywidget
                           , separator
                           , gmailwidget
                           , separator
                           , clockwidget
                           , s == 1 and systray or nil
                           }
    -- Add it to each screen
    statusbar[s].screen = s
end

--}}}
-------------------------------------------------------------------------------------
--{{{ Bindings

-- What happens when we click the desktop
awesome.buttons({
    button({ }                      , 3         , function () mainmenu:toggle() end),
    button({ }                      , 4         , awful.tag.viewnext),
    button({ }                      , 5         , awful.tag.viewprev)
})

keynumber = 9
for i = 1, keynumber do
    -- Mod+F1-F9 focuses tag 1-9
    keybinding({ modMask }, "F"..i,
    function ()
        local screen = mouse.screen
        if tags[screen][i] then
            awful.tag.viewonly(tags[screen][i])
        end
    end):add()
    -- Mod+Ctrl+F1-F9 additionally shows clients from tag 1-9
    keybinding({ modMask, "Control" }, "F"..i,
    function ()
        local screen = mouse.screen
        if tags[screen][i] then
            tags[screen][i].selected = not tags[screen][i].selected
        end
    end):add()
    -- Mod+Shift+F1-F9 moves the current client to tag 1-9
    keybinding({ modMask, "Shift" }, "F"..i,
    function ()
        if client.focus then
            if tags[client.focus.screen][i] then
                awful.client.movetotag(tags[client.focus.screen][i])
            end
        end
    end):add()
end
-- Shows or hides the statusbar
keybinding({ modMask }              , "b"       , function () 
    if statusbar[mouse.screen].screen == nil then 
        statusbar[mouse.screen].screen = mouse.screen
    else
        statusbar[mouse.screen].screen = nil
    end
end):add()
-- These should be straightforward...
keybinding({ modMask }              , "Left"    , awful.tag.viewprev):add()
keybinding({ modMask }              , "Right"   , awful.tag.viewnext):add()
keybinding({ modMask }              , "x"       , function () awful.util.spawn(term) end):add()
keybinding({ modMask }              , "f"       , function () awful.util.spawn(browser) end):add()
--keybinding({ modMask }              , "t"       , function () awful.util.spawn(fileManager) end):add()
keybinding({ modMask, "Control" }   , "r"       , function () promptbox[mouse.screen].text = awful.util.escape(awful.util.restart()) end):add()
keybinding({ modMask, "Shift" }     , "q"       , awesome.quit):add()
keybinding({ modMask }              , "m"       , awful.client.maximize):add()
keybinding({ modMask }              , "c"       , function () client.focus:kill() end):add()
keybinding({ modMask }              , "j"       , function () awful.client.focus.byidx(1); client.focus:raise() end):add()
keybinding({ modMask }              , "k"       , function () awful.client.focus.byidx(-1);  client.focus:raise() end):add()
keybinding({ modMask, "Control" }   , "space"   , awful.client.togglefloating):add()
keybinding({ modMask, "Control" }   , "Return"  , function () client.focus:swap(awful.client.master()) end):add()
keybinding({ modMask }              , "Tab"     , awful.client.focus.history.previous):add()
keybinding({ modMask }              , "u"       , awful.client.urgent.jumpto):add()
keybinding({ modMask, "Shift" }     , "r"       , function () client.focus:redraw() end):add()
keybinding({ modMask }              , "l"       , function () awful.tag.incmwfact(0.05) end):add()
keybinding({ modMask }              , "h"       , function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ modMask, "Shift" }     , "h"       , function () awful.tag.incnmaster(1) end):add()
keybinding({ modMask, "Shift" }     , "l"       , function () awful.tag.incnmaster(-1) end):add()
keybinding({ modMask, "Control" }   , "h"       , function () awful.tag.incncol(1) end):add()
keybinding({ modMask, "Control" }   , "l"       , function () awful.tag.incncol(-1) end):add()
keybinding({ modMask }              , "space"   , function () awful.layout.inc(layouts, 1) end):add()
keybinding({ modMask, "Shift" }     , "space"   , function () awful.layout.inc(layouts, -1) end):add()
keybinding({ modMask }              , "r"       , function () awful.prompt.run({ prompt = "Run: " }, promptbox[mouse.screen], awful.util.spawn, awful.completion.bash, os.getenv("HOME").."/.cache/awesome/history") end):add()
keybinding({ }                      , "#160"    , function () awful.util.spawn("dvol -t") end):add()
keybinding({ }                      , "#174"    , function () awful.util.spawn("dvol -d 2") end):add()
keybinding({ }                      , "#176"    , function () awful.util.spawn("dvol -i 2") end):add()
keybinding({ }                      , "#162"    , function () awful.util.spawn("mpc toggle") end):add()
keybinding({ }                      , "#164"    , function () awful.util.spawn("mpc stop") end):add()
keybinding({ }                      , "#153"    , function () awful.util.spawn("mpc next") end):add()
keybinding({ }                      , "#144"    , function () awful.util.spawn("mpc prev") end):add()
keybinding({ }                      , "#159"    , function () awful.util.spawn("urxvtc -e ncmpcpp") end):add()

--}}}
--------------------------------------------------------------------------------
--{{{ Hooks

-- Gets executed when focusing a client
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Gets executed when unfocusing a client
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Gets executed when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Gets executed when unmarking a client
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Gets executed when the mouse enters a client
awful.hooks.mouse_enter.register(function (c)
    if awful.layout.get(c.screen) ~= "magnifier"
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Gets executed when a new client appears
awful.hooks.manage.register(function (c)
    -- Add mouse binds
    c:buttons({ button({ }, 1, function (c) client.focus = c; c:raise() end)
              , button({ modMask }, 1, function (c) c:mouse_move() end)
              , button({ modMask }, 3, function (c) c:mouse_resize() end)
              })
    
    -- Set border anyway
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal
    client.focus = c

    -- Check if the application should be floating
    local cls = c.class
    local inst = c.instance
    if floatApps[cls] then
        c.floating = floatApps[cls]
    elseif floatApps[inst] then
        c.floating = floatApps[inst]
    end
    
    -- Prevent new clients from becoming master
    awful.client.setslave(c)

    -- Inogre size hints usually given out by terminals (prevent gaps between windows)
    c.honorsizehints = false
end)

-- Gets exeucted when arranging the screen (as in, tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    -- Set the layout text
    local layout = awful.layout.get(screen)
    if layout then
        layouticon[screen].text = returnLayoutText(awful.layout.get(screen))
    else
        layouticon[screen].text = nil
    end

    -- Give focus to the latest client in history if no window has focus
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)

-- Timed hooks for the widget functions
-- 1 second
awful.hooks.timer.register(1, function ()
    clockInfo("%d/%m/%Y", "%T")
end)

-- 5 seconds
awful.hooks.timer.register(5, function()
    wifiInfo("wlan0")
end)

-- 20 seconds
awful.hooks.timer.register(20, function()
    memInfo()
    batteryInfo("BAT1")
end)

-- 115 seconds
awful.hooks.timer.register(115, function()
    os.execute(os.getenv("HOME").."/.gmail.py > /tmp/gmail-temp &")
end)

-- 120 seconds
awful.hooks.timer.register(120, function()
    gmailInfo("/tmp/gmail-temp")
end)

--}}}
