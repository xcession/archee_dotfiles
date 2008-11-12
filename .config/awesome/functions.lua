-------------------------------------------------------------------------------------
--{{{ Functions

---- Markup functions
function setBg(color, text)
    return '<bg color="'..color..'" />'..text
end

function setFg(color, text)
    return '<span color="'..color..'">'..text..'</span>'
end

function setBgFg(bgcolor, fgcolor, text)
    return '<bg color="'..bgcolor..'" /><span color="'..fgcolor..'">'..text..'</span>'
end

function setFont(font, text)
    return '<span font_desc="'..font..'">'..text..'</span>'
end

---- Layouttext function
function returnLayoutText(layout)
    return setFg(beautiful.fg_focus, " | ")..layoutText[layout]..setFg(beautiful.fg_focus, " | ")
end

---- Widget functions
-- Clock
function clockInfo(dateformat, timeformat)
    local date = os.date(dateformat)
    local time = os.date(timeformat)
    
    clockwidget.text = date..spacer..setFg(#3579A8, time)..spacer
end

-- Wifi signal strength
function wifiInfo(adapter)
    local f = io.open("/sys/class/net/"..adapter.."/wireless/link")
    local wifiStrength = f:read()
    f:close()
    
    if wifiStrength == "0" then
        wifiStrength = setFg("#ff6565", wifiStrength.."%")
    else
        wifiStrength = wifiStrength.."%"
    end
    
    wifiwidget.text = spacer..setFg(#3579A8, "Wifi:")..spacer..wifiStrength..spacer
end

-- Battery (BAT1)
function batteryInfo(adapter)
    local fcur = io.open("/sys/class/power_supply/"..adapter.."/charge_now")    
    local fcap = io.open("/sys/class/power_supply/"..adapter.."/charge_full")
    local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")
    local cur = fcur:read()
    fcur:close()
    local cap = fcap:read()
    fcap:close()
    local sta = fsta:read()
    fsta:close()
    
    local battery = math.floor(cur * 100 / cap)
    
    if sta:match("Charging") then
        dir = "^"
        battery = "A/C"..spacer.."("..battery..")"
    elseif sta:match("Discharging") then
        dir = "v"
        if tonumber(battery) >= 25 and tonumber(battery) <= 50 then
            battery = setFg("#e6d51d", battery)
        elseif tonumber(battery) < 25 then
            if tonumber(battery) <= 10 then
                battery = setFg("#ff0000", battery)
            end
            battery = setFg("#ff6565", battery)
        else
            battery = battery
        end
    else
        dir = "="
        battery = "A/C"
    end
    
    batterywidget.text = spacer..setFg(#3579A8, "Bat:")..spacer..dir..battery..dir..spacer
end

-- Memory
function memInfo()
    local f = io.open("/proc/meminfo")

    for line in f:lines() do
        if line:match("^MemTotal.*") then
            memTotal = math.floor(tonumber(line:match("(%d+)")) / 1024)
        elseif line:match("^MemFree.*") then
            memFree = math.floor(tonumber(line:match("(%d+)")) / 1024)
        elseif line:match("^Buffers.*") then
            memBuffers = math.floor(tonumber(line:match("(%d+)")) / 1024)
        elseif line:match("^Cached.*") then
            memCached = math.floor(tonumber(line:match("(%d+)")) / 1024)
        end
    end
    f:close()

    memFree = memFree + memBuffers + memCached
    memInUse = memTotal - memFree
    memUsePct = math.floor(memInUse / memTotal * 100)

    memwidget.text = spacer..setFg(beautiful.fg_focus, "Mem:")..spacer..memUsePct.."%"..spacer.."("..memInUse.."M)"..spacer
end

--}}}
