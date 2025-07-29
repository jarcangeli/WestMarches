extends Control
class_name QuestRewardsDisplay

@export var item_rewards_container : ItemDisplayContainer
@export var currency_rewards_label : Label
@export var quest_name_label : Label
@export var quest_description_label : Label

func set_quest(quest : Quest):
	if quest_name_label:
		quest_name_label.text = quest.quest_name
	if quest_description_label:
		quest_description_label.text = quest.quest_description
	item_rewards_container.clear_item_views()
	item_rewards_container.add_items(quest.get_player_rewards() + quest.get_party_rewards())
	currency_rewards_label.text = str(quest.get_gold_reward())
