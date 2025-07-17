extends Control
class_name QuestRewardUI

signal quest_abandoned()
signal quest_finished()

@onready var selected_coins_display: HBoxContainer = %SelectedCoinsDisplay
@onready var available_party_coins_label: Label = %AvailablePartyCoinsLabel
@onready var owed_party_coins_label: Label = %OwedPartyCoinsLabel
@onready var loot_container: VBoxContainer = %LootContainer
@onready var returned_items_display: ItemDisplayContainer = %ReturnedItemsDisplay

@onready var items_display_container: ItemDisplayContainer = %ItemsDisplayContainer
@onready var item_rewards: ItemContainer = %ItemRewards

var current_quest : Quest = null

func setup_quest_reward_ui(quest : Quest):
	current_quest = quest
	var coins : int = quest.party.get_gold()
	var debt : int = quest.party.get_debt() # quest.get_currency_rewards().gold + 
	available_party_coins_label.text = str(coins)
	owed_party_coins_label.text = str(debt)
	loot_container.clear_item_views()
	loot_container.add_items(quest.get_rewards())
	items_display_container.clear_item_views()
	selected_coins_display.initialise(debt, coins)
	
	# Preview returned items
	returned_items_display.clear_item_views()
	for character : Character in quest.party.get_characters():
		var loaned_items = character.get_loaned_items()
		returned_items_display.add_items(loaned_items)

func undo_quest_reward_ui_setup():
	if current_quest:
		current_quest.add_rewards(loot_container.item_container.get_items())
	
	returned_items_display.clear_item_views()

func _on_take_rewards_button_pressed() -> void:
	if not current_quest:
		push_error("Trying to take rewards for null quest")
		return
	Globals.player_inventory.add_items(item_rewards.get_items())
	# Return items
	for character : Character in current_quest.party.get_characters():
		var loaned_items = character.get_loaned_items()
		Globals.player_inventory.add_items(loaned_items)
	current_quest.complete()
	current_quest = null
	quest_finished.emit()

func _on_abandon_quest_button_pressed() -> void:
	#TODO: Return equiped items to adventurers
	undo_quest_reward_ui_setup()
	current_quest = null
	quest_abandoned.emit()
