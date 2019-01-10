--
-- connect.lua
--

require "configuration"

--- WIFI CONFIGURATION ---
local config = {}
config["ssid"] = CONF_SSID
config["pwd"]  = CONF_PASS

local WIFI_SIGNAL_MODE = wifi.PHYMODE_N

--- IP CONFIG (Leave blank to use DHCP) ---
local ESP8266_IP=""
local ESP8266_NETMASK=""
local ESP8266_GATEWAY=""
-----------------------------------------------

function connect_wifi(callback)

    print("Configuring wifi")

    --- Connect to the wifi network ---
    wifi.setmode(wifi.STATION) 
    wifi.setphymode(WIFI_SIGNAL_MODE)
    wifi.sta.config(config)

    print("Connecting to wifi")
    wifi.sta.connect()
    
    if ESP8266_IP ~= "" then
     wifi.sta.setip({ip=ESP8266_IP,netmask=ESP8266_NETMASK,gateway=ESP8266_GATEWAY})
    end
    -----------------------------------------------
    
    --- Check the IP Address ---
    
    local mytimer = tmr.create()
    
    function check_connection()
        if (wifi.sta.getip() ~= nil) 
        then
            print("Wifi connected: " .. wifi.sta.getip())
            mytimer:unregister()
            callback()
        end
    end
    
    mytimer:register(500, tmr.ALARM_AUTO, check_connection)
    mytimer:start()
end
