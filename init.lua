
require "network"
require "messaging"
require "motion"

tmr.alarm(0, 3000, 0, function() 
    connect_wifi(function()
        connect_mqtt(function(client) 
            motion(client)
        end)
    end)
end)
