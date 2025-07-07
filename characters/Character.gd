extends Node
class_name Character

@export var character_name : String

@export var level : int = 1

var debt : int = 0

func get_items():
	var items = []
	for node in get_children():
		if node is Item:
			items.append(node)
	return items
