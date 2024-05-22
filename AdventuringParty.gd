extends Node
class_name AdventuringParty

var active_quest : Quest = null

func get_characters():
	return get_children()
