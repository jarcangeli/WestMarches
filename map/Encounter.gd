@icon("res://assets/icons/logo.png") #Should be 16x16
extends Node2D
class_name Encounter

func get_monsters() -> Array[Character]:
	var monsters : Array[Character] = []
	for node in get_children():
		if node is Character:
			monsters.append(node)
	return monsters

func get_item_rewards():
	var items = []
	for node in get_children():
		if node is Item:
			items.append(node)
	return items

func add_item_rewards(items):
	for node in items:
		if node.get_parent():
			node.get_parent().remove_child(node)
		add_child(node)

func get_location():
	return get_parent()
