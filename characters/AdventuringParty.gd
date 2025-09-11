extends ItemContainer
class_name AdventuringParty

@export var display_name : String

var position = Vector2.ZERO

var quest = null
var gold := 5

func _ready() -> void:
	if display_name.is_empty():
		display_name = name
	SignalBus.quest_completed.connect(on_quest_completed)
	
	for character in get_characters():
		character.equip_best_gear()

func get_position():
	return position

func is_alive():
	return not get_characters(false).is_empty()

func get_characters(include_dead := false) -> Array[Character]:
	var characters : Array[Character] = []
	for node in get_children():
		if node is Character and (include_dead or node.is_alive()):
			characters.append(node)
	characters.sort_custom(custom_character_comparison)
	return characters

func custom_character_comparison(char_a : Character, char_b : Character):
	return char_a.get_level() > char_b.get_level()

func get_average_level():
	#TODO: Factor in gear to get power level
	var levels = 0
	var count = 0
	for character in get_characters():
		count += 1
		levels += character.get_power_level()
	return levels/float(count)

func get_gold():
	return gold

func get_power_level():
	var total = 0
	for character in get_characters():
		total += character.get_power_level()
	return total

func on_quest_completed(quest_completed : Quest):
	if quest_completed == quest:
		quest = null
		var disband_party := true
		for character in get_characters():
			if character.is_alive():
				disband_party = false
		if disband_party:
			if get_parent():
				get_parent().remove_child(self)
			Globals.character_graveyard.add_child(self)
		else:
			redistribute_items()
			sell_spare_items()

func redistribute_items():
	# Move loot to party
	for character in get_characters(true): # include dead
		if character.dead:
			character.unequip_all_items()
		add_items(character.get_unequipped_items())
	# Equip best gear (including shared pool)
	for character : Character in get_characters():
		character.equip_best_gear(self)
		add_items(character.get_unequipped_items())

func get_loaned_items():
	var loaned_items = []
	for item in get_items():
		if item.loaned_character:
			loaned_items.append(item)
	for character in get_characters(true):
		var char_loaned_items = character.get_loaned_items()
		for item in char_loaned_items:
			loaned_items.append(item)
	return loaned_items

func sell_spare_items():
	if not Globals.shop:
		push_error("No shop to sell spare items to")
		return
	for item in get_items():
		Globals.shop.sell_item(self, item)
	for character in get_characters():
		for item in character.get_unequipped_items():
			Globals.shop.sell_item(self, item)
