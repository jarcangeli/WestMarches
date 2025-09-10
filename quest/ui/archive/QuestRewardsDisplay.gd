extends Control
class_name QuestRewardsDisplay

@export var item_rewards_container : ItemDisplayContainer
@export var currency_rewards_label : Label
@export var quest_name_label : Label
@export var quest_description_label : Label

@onready var collect_rewards_button: Button = %CollectRewardsButton
@onready var tpk_button: Button = %TPKButton

func set_quest(quest : Quest):
	if quest_name_label:
		quest_name_label.text = quest.quest_name
	if quest_description_label:
		quest_description_label.text = quest.quest_description
	var tpk = quest.lost()
	collect_rewards_button.visible = not tpk
	tpk_button.visible = tpk
	item_rewards_container.clear_item_views()
	if not tpk:
		item_rewards_container.add_items(quest.get_player_rewards() + quest.get_party_rewards())
		currency_rewards_label.text = str(quest.get_gold_reward())
	else:
		currency_rewards_label.text = "0"
