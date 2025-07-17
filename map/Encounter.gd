@icon("res://assets/icons/logo.png") #Should be 16x16
extends Node2D
class_name Encounter

func get_monsters():
	var monsters = []
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

func get_location():
	return get_parent()
