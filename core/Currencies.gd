extends Node
class_name Currencies

signal changed()

@export var gold = 0

func print_to_string():
	return str(int(gold)) + " gp"

func add_currencies(other_currencies, duplicated = false):
	gold += other_currencies.gold
	if not duplicated:
		other_currencies.clear()
	emit_signal("changed")

func add_gold(amount):
	gold += clampi(amount, 0, amount)
	emit_signal("changed")

func remove_gold(amount):
	gold -= clampi(amount, 0, amount)
	emit_signal("changed")

func clear():
	gold = 0
	emit_signal("changed")
