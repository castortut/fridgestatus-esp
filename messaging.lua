function connect_mqtt(callback)

    -- Start a watchdog timer to reset if no response from server in 100s
    local WDT_TIMEOUT = 100
    local timeout = WDT_TIMEOUT
    local wdt = tmr.create()
    wdt:register(1000, tmr.ALARM_AUTO, function() 
        timeout = timeout - 1
        if ( timeout <= 0 )
        then
            print("No keepalive from server in 100s, restarting")
            node.restart()
        end
    end)
    print("Starting watchdog (watches server-sent keepalives)")
    wdt:start()


    m = mqtt.Client(node.chipid(), 120)

    m:on("message", function(client, topic, data)
        print("Received data on topic " .. topic)
        if (topic == "/keepalive")
        then
            print("Received keepalive, resetting WDT")
            timeout = WDT_TIMEOUT
        end
    end)

    net.dns.setdnsserver("1.1.1.1", 0)
    net.dns.setdnsserver("8.8.8.8", 1)
    print("Looking up the MQTT broker in DNS")
    net.dns.resolve("mqtt.svc.cave.avaruuskerho.fi", function(sk, ip)
        if (ip == nil)
        then
            print("DNS resolution error")
            node.reset()
        end

        print("MQTT broker resolved to:" .. ip)

        m:connect(ip, 1883, 0, function(client)
            print("MQTT Connection succesful")
            client:publish("/iot/cave/hello/" .. node.chipid(), "Hello, I'm a motion sensor", 0, 0, function(client) print("sent") end)
            client:subscribe("/keepalive", 0, function(client) print("Subscribed to keepalives") end)
            callback(client)
        end)
    end)
end
