extends HBoxContainer
class_name QuestEquipUI

signal quest_abandoned()
signal quest_started()

@export var character_equip_ui_scene : Resource
@onready var inventory_display_container: ItemDisplayContainer = $InventoryDisplayContainer

@export var characters_container : Node
@export var value_label : Label
@export var reward_label : Label

@onready var reward_ui: Control = %QuestRewardUI

var current_quest : Quest = null
var loaned_item_value = 0

func _ready():
	SignalBus.player_inventory_changed.connect(self.on_player_inventory_changed)
	on_player_inventory_changed()
	
	SignalBus.item_equipped.connect(on_item_equipped)
	SignalBus.item_unequipped.connect(on_item_unequipped)

func on_quest_selected(quest : Quest):
	current_quest = quest
	var party : AdventuringParty = quest.party
	if not is_instance_valid(party) or len(party.get_characters()) == 0:
		push_error("Equip screen for quest opened with invalid party")
		clear_characters()
		return
	var characters = party.get_characters()
	setup_characters(characters)

func setup_characters(characters):
	clear_characters()
	
	for character in characters:
		var char_ui = character_equip_ui_scene.instantiate()
		char_ui.call_deferred("set_character", character)
		char_ui.name = character.character_name #TODO: Does this handle repeat names
		characters_container.add_child(char_ui)

func clear_characters():
	for node in characters_container.get_children():
		#TODO: Unequip items?
		node.queue_free()

#TODO: Inherit ItemDisplayContainer to create a re-usable player invent display?
func on_player_inventory_changed():
	inventory_display_container.clear_item_views()
	if Globals.player_inventory:
		inventory_display_container.add_items(Globals.player_inventory.get_children())

func on_item_equipped(item, _slot):
	loaned_item_value += item.get_value()
	value_label.text = str(loaned_item_value) + " gp"
	reward_label.text = str(loaned_item_value) + " gp"

func on_item_unequipped(item, _slot):
	loaned_item_value -= item.get_value()
	value_label.text = str(loaned_item_value) + " gp"
	reward_label.text = str(loaned_item_value) + " gp"

func _on_abandon_quest_button_pressed() -> void:
	#TODO: Return all items?
	current_quest = null
	quest_abandoned.emit()

func _on_start_quest_button_pressed() -> void:
	if not is_instance_valid(current_quest):
		quest_abandoned.emit()
		return
	
	for character_container in characters_container.get_children():
		var character = character_container.character
		var equipped_items = character_container.get_equipped_items()
		
		for item in equipped_items:
			character.debt += item.get_value()
			item.get_parent().remove_child(item)
			character.add_child(item)
			item.loaned_character = character
	
	SignalBus.player_inventory_changed.emit()
	current_quest.start(current_quest.party)
	
	quest_started.emit()
