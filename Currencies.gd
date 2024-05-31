extends Node
class_name Currencies

signal changed()

export var gold = 0

func to_string():
	return str(gold) + " gp"

func add_currencies(other_currencies, duplicate=false):
	gold += other_currencies.gold
	if not duplicate:
		other_currencies.clear()
	emit_signal("changed")

func clear():
	gold = 0
	emit_signal("changed")
