extends Node
class_name Currencies

signal changed()
signal gold_added(amount : int)

@export var gold = 0

func print_to_string():
	return str(int(gold)) + " gp"

func add_currencies(other_currencies, duplicated = false):
	gold += other_currencies.gold
	if not duplicated:
		other_currencies.clear()
	emit_signal("changed")

func add_gold(amount : int):
	amount = clampi(amount, 0, amount)
	if amount == 0:
		return
	gold += amount
	emit_signal("changed")
	gold_added.emit(amount)

func remove_gold(amount):
	gold -= clampi(0, amount, amount)
	emit_signal("changed")

func clear():
	gold = 0
	emit_signal("changed")
