
# Fridge switches

 ESP8266 (NodeMcu firmware) code to read a set of switches and publish changes over MQTT.

## Why?

The device is intended as an easy way to mark some products in a fridge as sold-out
so that some other person can have a "shopping list" without having to check the fridge

## Wiring

Switches should be connected to the following IOs of an NodeMcu devboard:
D1, D2, D5, D6, D7, D12

## Operation

When a change in one of the switches is detected, an message is published to the given MQTT topic
which should be read/handled by another piece of software.

The states of the switches are written as a bunch of '0' or '1' concatenated into a string.

Example update payload could be: 010000
