extends Node

# Handle error when connecting
func hconnect(signal_name: String, target: Object, method: String, binds: Array = [  ], flags: int = 0):
	var error = connect(signal_name, target, method, binds, flags)
	if error:
		push_error(error)

signal item_equipped(item, slot)
signal item_unequipped(item, slot)

signal player_inventory_changed()
signal player_currencies_changed()

signal time_advanced()

signal quest_created(quest)
signal quest_started(quest)
signal quest_finished(quest) 	# party has finished steps
signal quest_completed(quest) 	# player has resolved rewards
