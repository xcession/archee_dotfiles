-------------------------------------------------------------------------------------
--{{{ Functions

---- Markup functions
function setBg(color, text)
    return '<bg color="' .. color .. '" />' .. text
end

function setFg(color, text)
    return '<span color="' .. color .. '">' .. text .. '</span>'
end

function setBgFg(bgcolor, fgcolor, text)
    return '<bg color="' .. bgcolor .. '" /><span color="' .. fgcolor .. '">' .. text .. '</span>'
end

function setFont(font, text)
    return '<span font_desc="' .. font .. '">' .. text .. '</span>'
end

---- Widget functions
-- Battery
function batteryInfo(adapter)
    local fcur = io.open("/sys/class/power_supply/" .. adapter .. "/charge_now")    
    local fcap = io.open("/sys/class/power_supply/" .. adapter .. "/charge_full")
    local fsta = io.open("/sys/class/power_supply/" .. adapter .. "/status")
    local cur = fcur:read()
    fcur:close()
    local cap = fcap:read()
    fcap:close()
    local sta = fsta:read()
    fsta:close()
    
    local battery = math.floor(cur * 100 / cap)
    
    if sta:match("Charging") then
        battery = "A/C " .. battery
        battery = setFg("#f57900", battery)
    elseif sta:match("Discharging") then
        if tonumber(battery) >= 25 and tonumber(battery) <= 50 then
            battery = setFg("#ffc123", battery)
        elseif tonumber(battery) < 25 then
            if tonumber(battery) <= 10 then
                naughty.notify({
                                    title    = "Battery Warning",
                                    text     = "Battery low! " .. battery .. "% left!",
                                    timeout  = 5,
                                    position = "top_right",
                                    fg       = beautiful.fg_focus,
                                    bg       = beautiful.bg_focus
                               })
            end
            battery = setFg("#ff6565", battery)
        else
            battery = battery
            battery = setFg("#93d44f", battery)
        end
    else
        battery = "A/C"
        battery = setFg("#93d44f", battery)
    end
    
    batterywidget.text = " " .. battery .. " "
end

--}}}
