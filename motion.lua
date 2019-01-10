function motion(client)

    local IO_PIN = 7

    gpio.mode(IO_PIN, gpio.INPUT)

    last_state = 0

    t = tmr.create()
    t:register(200, tmr.ALARM_AUTO, function() 
        new_state = gpio.read(IO_PIN)
        if(last_state == 0 and new_state == 1)
        then
            print("Motion detected")
            client:publish("/iot/cave/motion1", "detected", 0, 0, function(client) print("sent") end)
        end
        last_state = new_state
    end)
    t:start()
end
