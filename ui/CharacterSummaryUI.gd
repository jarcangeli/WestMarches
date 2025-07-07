extends Control

@export var item_display_scene : Resource

@onready var item_container = $ScrollContainer/CenterContainer/ItemDisplayContainer

func set_character(character):
	$NameLabel.text = character.character_name
	$HBoxContainer/LevelLabel.text = str(character.level)
	
	clear_items()
	for item in character.get_items():
		var item_display = item_display_scene.instantiate()
		item_display.drag_enabled = false
		item_container.add_child(item_display)
		item_display.set_item(item)

func clear_items():
	for item in item_container.get_children():
		item.queue_free()
