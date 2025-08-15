extends Control
class_name QuestRewardUI

signal quest_abandoned()
signal quest_finished()

@onready var party_loot_display: Container = %LootContainer
@onready var returned_items_display: ItemDisplayContainer = %ReturnedItemsDisplay
@onready var player_loot_display: ItemDisplayContainer = %ItemsDisplayContainer
@onready var coins_reward_label: Label = %CoinsRewardLabel

var current_quest : Quest = null

func setup_quest_reward_ui(quest : Quest):
	current_quest = quest
	player_loot_display.clear_item_views()
	player_loot_display.add_items(quest.get_player_rewards())
	party_loot_display.clear_item_views()
	party_loot_display.add_items(quest.get_party_rewards()) #TODO: Gets all the remaining
	coins_reward_label.text = str(quest.get_gold_reward())
	
	# Preview returned items
	returned_items_display.clear_item_views()
	for character : Character in quest.party.get_characters():
		var loaned_items = character.get_loaned_items()
		returned_items_display.add_items(loaned_items)

func undo_quest_reward_ui_setup():
	returned_items_display.clear_item_views()

func _on_take_rewards_button_pressed() -> void:
	if not current_quest:
		push_error("Trying to take rewards for null quest")
		return
	if current_quest.reward_tier >= Quest.RewardTier.COINS:
		Globals.player_currencies.add_gold(current_quest.get_gold_reward())
		#TODO: Deduct from party?
	if current_quest.reward_tier == Quest.RewardTier.CHOICE:
		Globals.player_inventory.add_items(player_loot_display.get_selected_items())
	elif current_quest.reward_tier == Quest.RewardTier.RANDOM:
		Globals.player_inventory.add_items(player_loot_display.get_displayed_items())
	# Return items
	for character : Character in current_quest.party.get_characters():
		var loaned_items = character.get_loaned_items()
		Globals.player_inventory.add_items(loaned_items)
		
		#TODO: Just adds items to the last character
		#TODO: Want a way to redistribute NEW items between party members (smartly)
		#TODO: Let the player move items between party members in the tavern
		if current_quest.reward_tier == Quest.RewardTier.CHOICE:
			character.add_items(player_loot_display.get_unselected_items())
		character.add_items(party_loot_display.get_displayed_items())
	current_quest.complete()
	current_quest = null
	quest_finished.emit()

func _on_abandon_quest_button_pressed() -> void:
	#TODO: Return equiped items to adventurers
	undo_quest_reward_ui_setup()
	current_quest = null
	quest_abandoned.emit()
