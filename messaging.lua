function connect_mqtt(callback)
    m = mqtt.Client(node.chipid(), 120)

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
            callback(client)
        end)
        
    end)

    m:on("connect", callback)
    return 
end
