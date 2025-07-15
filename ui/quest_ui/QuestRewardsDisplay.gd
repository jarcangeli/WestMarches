extends Control

@export var item_rewards_container : ItemDisplayContainer
@export var currency_rewards_label : Label
@export var debt_rewards_label : Label
@export var quest_name_label : Label
@export var quest_description_label : Label

func set_quest(quest : Quest):
	if quest_name_label:
		quest_name_label.text = quest.quest_name
	if quest_description_label:
		quest_description_label.text = quest.quest_description
	item_rewards_container.clear_item_views()
	item_rewards_container.add_items(quest.get_rewards())
	var currency_rewards : Currencies = quest.get_currency_rewards()
	if currency_rewards:
		currency_rewards_label.text = currency_rewards.print_to_string()
	else:
		currency_rewards_label.text = "0 gp"
	if quest.finished and debt_rewards_label:
		debt_rewards_label.visible = true
		debt_rewards_label.text = "Debt: " + str(quest.party.get_debt()) + " gp"
	elif debt_rewards_label:
		debt_rewards_label.visible = false
