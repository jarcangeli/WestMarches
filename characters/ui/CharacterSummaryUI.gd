extends Control

@export var item_display_scene : Resource

@onready var item_container = %ItemDisplayContainer
@onready var stats_display: Control = %StatsDisplay
@onready var equipment_layout: EquipmentSlotLayout = %EquipmentLayout

var character = null

func set_character(_character : Character):
	character = _character
	if character == null:
		return
	#TODO: Connect to character changed signals
	character.equip_best_gear()
	equipment_layout.set_character(character)
	update_displayed_stats()
	update_displayed_items()

func update_displayed_stats():
	$NameLabel.text = character.character_name
	$ClassLabel.text = "Level %d %s" % [character.get_level(), Character.character_class_to_string(character.character_class)]
	$LevelContainer/LevelLabel.text = str(character.get_level())
	$PowerContainer/PowerLabel.text = str(character.get_power_level())
	stats_display.set_stats(character.stats.get_values())

func update_displayed_items():
	clear_items()
	for item in character.get_items():
		var item_display = item_display_scene.instantiate()
		item_display.drag_enabled = false
		item_display.select_enabled = false
		item_container.add_child(item_display)
		item_display.set_item(item)


func clear_items():
	for item in item_container.get_children():
		item.queue_free()

func set_scroll_enabled(enabled):
	%ScrollContainer.vertical_scroll_mode = int(enabled)
