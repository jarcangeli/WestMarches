@icon("res://assets/icons/logo.png") #Should be 16x16
extends Node2D
class_name Encounter

var encounter_name : String
var description : String

func _init(data : EncounterData = null): #TODO: Remove null default
	if not data:
		return
	encounter_name = data.encounter_name
	description = data.description
	name = encounter_name
	for monster_name in data.monster_names:
		LazyLoadCharacter.run(monster_name, self)
	for item_name in data.item_names:
		LazyLoadItem.run(item_name, self)

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
