extends Node

var day = 1

func _ready():
	SignalBus.hconnect("advance_day", self, "on_advance_day")

func on_advance_day():
	day += 1
	print("Day advanced to ", day)
