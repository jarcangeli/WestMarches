extends Node
class_name AdventuringParty

@export var display_name : String

var position = Vector2.ZERO

#TODO: Track what quest we are on

func _ready() -> void:
	if display_name.is_empty():
		display_name = name

func get_position():
	return position

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

func get_debt():
	var debt = 0
	for character in get_characters():
		debt += character.debt
	return debt

func get_gold():
	return 5
