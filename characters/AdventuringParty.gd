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

func get_position():
	return position

func is_alive():
	for character in get_characters():
		if character.is_alive():
			return true
	return false

func get_characters() -> Array[Character]:
	var characters : Array[Character] = []
	for node in get_children():
		if node is Character:
			characters.append(node)
	return characters

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

func on_quest_completed(quest_completed : Quest):
	if quest_completed == quest:
		quest = null
		var disband_party := true
		for character in get_characters():
			if not character.is_alive():
				character.on_death()
			else:
				disband_party = false
		if disband_party:
			queue_free() #TODO: A proper send off
