@icon("res://assets/icons/logo.png") #Should be 16x16
extends Node2D
class_name Encounter

var encounter_name : String
var description : String
var repeatable := false
var dependency : String

#TODO: Why am I duplicating all these?
var on_start_message : String
var on_combat_start_message : String
var on_win_message : String
var on_lose_message : String

var monster_names : Array[String] = []
var item_names : Array[String] = []

var poi_data : POIData

func _init(data : EncounterData = null): #TODO: Remove null default
	if not data:
		return
	encounter_name = data.encounter_name
	description = data.description
	repeatable = data.repeatable
	dependency = data.dependency
	name = encounter_name
	monster_names = data.monster_names
	item_names = data.item_names
	on_start_message = data.on_start_message
	on_combat_start_message = data.on_combat_start_message
	on_win_message = data.on_win_message
	on_lose_message = data.on_lose_message
	poi_data = data.poi_data
	generate_monsters()
	generate_items()

func generate_monsters():
	for node in get_children():
		if node is Character:
			node.queue_free()
	for monster_name in monster_names:
		LazyLoadCharacter.run(monster_name, self)

func generate_items():
	for node in get_children():
		if node is Item:
			node.queue_free()
	for item_name in item_names:
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
