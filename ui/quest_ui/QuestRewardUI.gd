extends Control
class_name QuestRewardUI

signal quest_abandoned()
signal quest_finished()

@onready var selected_coins_display: HBoxContainer = %SelectedCoinsDisplay
@onready var available_party_coins_label: Label = %AvailablePartyCoinsLabel
@onready var owed_party_coins_label: Label = %OwedPartyCoinsLabel
@onready var loot_container: VBoxContainer = %LootContainer

@onready var item_rewards: ItemContainer = %ItemRewards

var current_quest : Quest = null

func setup_quest_reward_ui(quest : Quest):
	current_quest = quest
	var coins : int = quest.party.get_gold()
	var debt : int = quest.get_currency_rewards().gold + quest.party.get_debt()
	available_party_coins_label.text = str(coins)
	owed_party_coins_label.text = str(debt)
	loot_container.clear_item_views()
	loot_container.add_items(quest.get_rewards())
	selected_coins_display.initialise(debt, coins)

func undo_quest_reward_ui_setup():
	if current_quest:
		current_quest.add_rewards(loot_container.item_container.get_items())

func _on_take_rewards_button_pressed() -> void:
	if not current_quest:
		push_error("Trying to take rewards for null quest")
		return
	Globals.player_inventory.add_items(item_rewards.get_items())
	current_quest.complete()
	current_quest = null
	quest_finished.emit()

func _on_abandon_quest_button_pressed() -> void:
	undo_quest_reward_ui_setup()
	current_quest = null
	quest_abandoned.emit()
