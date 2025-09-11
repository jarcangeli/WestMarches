extends PanelContainer
class_name QuestRewardPanel

#TODO: Handle failed?
signal quest_completed(quest : Quest)

@onready var reward_ui_container: VBoxContainer = %RewardUIContainer
@onready var party_loot_display: Container = %PartyLootContainer
@onready var returned_items_display: ItemDisplayContainer = %ReturnedItemsDisplay
@onready var player_loot_display: ItemDisplayContainer = %PlayerLootDisplay
@onready var coins_reward_label: Label = %CoinsRewardLabel
@onready var loss_ui: Container = %LossUI

var current_quest : Quest = null

func hide_rewards():
	current_quest = null
	reward_ui_container.visible = false
	loss_ui.visible = false

func show_rewards(quest : Quest):
	current_quest = quest
	
	if current_quest == null or current_quest.lost():
		show_loss_screen()
		return
	
	reward_ui_container.visible = true
	loss_ui.visible = false

	player_loot_display.clear_item_views()
	var reward_count = quest.get_player_rewards().size()
	player_loot_display.add_items(quest.get_player_rewards())
	player_loot_display.columns = min(reward_count, 5)
	
	party_loot_display.clear_item_views()
	party_loot_display.add_items(quest.get_party_rewards()) #TODO: Gets all the remaining
	coins_reward_label.text = str(quest.get_gold_reward())
	
	# Preview returned items
	returned_items_display.clear_item_views()
	for character : Character in quest.party.get_characters():
		var loaned_items = character.get_loaned_items()
		returned_items_display.add_items(loaned_items)

func show_loss_screen():
	reward_ui_container.visible = false
	loss_ui.visible = true

func undo_quest_reward_ui_setup():
	returned_items_display.clear_item_views()

func _on_take_rewards_button_pressed() -> void:
	if not current_quest:
		push_error("Trying to take rewards for null quest")
		return
	# Return items
	for character : Character in current_quest.party.get_characters(true):
		var loaned_items = character.get_loaned_items()
		Globals.player_inventory.add_items(loaned_items)
		# Just adds items to the last character, items will be redistributed by the party
		if current_quest.reward_tier == Quest.RewardTier.CHOICE:
			character.add_items(player_loot_display.get_unselected_items())
		character.add_items(party_loot_display.get_displayed_items())
	
	# Player rewards
	if current_quest.reward_tier >= Quest.RewardTier.COINS:
		Globals.player_currencies.add_gold(current_quest.get_gold_reward())
		#TODO: Deduct from party?
	if current_quest.reward_tier == Quest.RewardTier.CHOICE:
		Globals.player_inventory.add_items(player_loot_display.get_selected_items())
	elif current_quest.reward_tier == Quest.RewardTier.RANDOM:
		Globals.player_inventory.add_items(player_loot_display.get_displayed_items())
	
	current_quest.complete()
	current_quest = null
	quest_completed.emit(current_quest)


func _on_accept_defeat_button_pressed() -> void:
	if not current_quest:
		push_error("Trying to accept defeat for null quest")
		return
	current_quest.complete()
	current_quest = null
	quest_completed.emit(current_quest)
