extends Node
class_name AdventuringParty

func get_characters():
	var characters = []
	for node in get_children():
		if node is Character:
			characters.append(node)
	return characters
