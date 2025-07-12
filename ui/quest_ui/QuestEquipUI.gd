extends HBoxContainer

signal quest_abandoned()
signal quest_started()
signal rewards_selected()

@export var character_equip_ui_scene : Resource

@export var characters_container : Node
@export var value_label : Label
@export var reward_label : Label
@export var equip_ui : Control
@export var reward_ui : Control

@onready var selected_coins_display: HBoxContainer = %SelectedCoinsDisplay
@onready var available_party_coins_label: Label = %AvailablePartyCoinsLabel
@onready var owed_party_coins_label: Label = %OwedPartyCoinsLabel

@onready var inventory_display_container = $ItemsDisplayContainer
@onready var loot_container: VBoxContainer = %LootContainer
@onready var party_container: VBoxContainer = %PartyContainer

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
	
	if quest.finished:
		equip_ui.visible = false
		reward_ui.visible = true
		party_container.visible = false
		loot_container.visible = true
		
		var coins : int = quest.party.get_gold()
		var debt : int = quest.get_currency_rewards().gold + quest.party.get_debt()
		available_party_coins_label.text = str(coins)
		owed_party_coins_label.text = str(debt)
		selected_coins_display.initialise(debt, coins)
	
		loot_container.clear_items()
		loot_container.add_items(quest.get_rewards())
	else:
		equip_ui.visible = true
		reward_ui.visible = false
		party_container.visible = true
		loot_container.visible = false

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
	inventory_display_container.clear_items()
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
	quest_abandoned.emit()

func _on_start_quest_button_pressed() -> void:
	quest_started.emit()

func _on_take_rewards_button_pressed() -> void:
	rewards_selected.emit()
