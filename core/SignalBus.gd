extends Node

signal item_equipped(item, slot)
signal item_unequipped(item, slot)
signal item_consumed(item)

signal player_inventory_changed()
signal player_currencies_changed()

signal time_advanced()

signal quest_created(quest)
signal quest_started(quest)
signal quest_finished(quest) 	# party has finished steps
signal quest_completed(quest) 	# player has resolved rewards
