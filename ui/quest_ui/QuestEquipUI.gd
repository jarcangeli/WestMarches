extends HBoxContainer

@export var character_equip_ui_scene : Resource

@export var character_container_path : NodePath
@onready var character_container = get_node(character_container_path)

@export var value_label_path : NodePath
@onready var value_label = get_node(value_label_path)

@export var reward_label_path : NodePath
@onready var reward_label = get_node(reward_label_path)

@onready var inventory_display_container = $ItemsDisplayContainer

var loaned_item_value = 0

func _ready():
	SignalBus.player_inventory_changed.connect(self.on_player_inventory_changed)
	on_player_inventory_changed()
	
	SignalBus.item_equipped.connect(on_item_equipped)
	SignalBus.item_unequipped.connect(on_item_unequipped)

func initialise():
	visible = false

func on_quest_selected(quest : Quest):
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
		character_container.add_child(char_ui)

func clear_characters():
	for node in character_container.get_children():
		#TODO: Unequip items?
		node.queue_free()

#TODO: Inherit ItemDisplayContainer to create a re-usable player invent display?
func on_player_inventory_changed():
	inventory_display_container.clear_items()
	if Globals.player_inventory:
		inventory_display_container.load_items(Globals.player_inventory.get_children())

func on_item_equipped(item, _slot):
	loaned_item_value += item.get_value()
	value_label.text = str(loaned_item_value) + " gp"
	reward_label.text = str(loaned_item_value) + " gp"

func on_item_unequipped(item, _slot):
	loaned_item_value -= item.get_value()
	value_label.text = str(loaned_item_value) + " gp"
	reward_label.text = str(loaned_item_value) + " gp"
