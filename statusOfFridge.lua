
local IO_PIN_1 = 1
local IO_PIN_2 = 2
local IO_PIN_3 = 5
local IO_PIN_4 = 6
local IO_PIN_5 = 7
local IO_PIN_6 = 12

function readSwitches()
	-- returns a string with status of switches pin_1, pin_2, etc
	-- eg 110000 means pin_1 and pin_2 (= products 1 and 2) are NOT sold out
	stateOf1 = gpio.read(IO_PIN_1)
	stateOf2 = gpio.read(IO_PIN_2)
	stateOf3 = gpio.read(IO_PIN_3)
	stateOf4 = gpio.read(IO_PIN_4)
	stateOf5 = gpio.read(IO_PIN_5)
	stateOf6 = gpio.read(IO_PIN_6)
	
	return stateOf1 .. stateOf2 .. stateOf3 .. stateOf4	.. stateOf5 .. stateOf6
end

function statusOfFridge(client)
	
	gpio.mode(IO_PIN_1, gpio.INPUT, gpio.PULLUP)
	gpio.mode(IO_PIN_2, gpio.INPUT, gpio.PULLUP)
	gpio.mode(IO_PIN_3, gpio.INPUT, gpio.PULLUP)
	gpio.mode(IO_PIN_4, gpio.INPUT, gpio.PULLUP)
	gpio.mode(IO_PIN_5, gpio.INPUT, gpio.PULLUP)
	gpio.mode(IO_PIN_6, gpio.INPUT, gpio.PULLUP)
	
    last_state = ""

    t = tmr.create()
    t:register(200, tmr.ALARM_AUTO, function() 
        new_state = readSwitches()
        if(last_state ~= new_state)
        then
            print("Product(s) sold out")
            client:publish("/iot/cave/fridgeSwitch0/" .. node.chipid(), new_state, 0, 0, function(client) print("sent") end)
        end
        last_state = new_state
    end)
    t:start()
end
