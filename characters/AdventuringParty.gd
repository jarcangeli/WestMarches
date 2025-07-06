extends Node
class_name AdventuringParty

var position = Vector2.ZERO

#TODO: Track what quest we are on

func get_position():
	return position

func get_characters():
	var characters = []
	for node in get_children():
		if node is Character:
			characters.append(node)
	return characters
