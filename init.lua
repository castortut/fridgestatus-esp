
require "network"
require "messaging"
require "statusOfFridge"

tmr.alarm(0, 3000, 0, function() 
    connect_wifi(function()
        connect_mqtt(function(client) 
            statusOfFridge(client)
        end)
    end)
end)
