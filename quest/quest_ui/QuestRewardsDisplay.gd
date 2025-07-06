extends Control

@export var item_rewards_container_path : NodePath
@onready var item_rewards_container = get_node(item_rewards_container_path)

@export var currency_rewards_label_path : NodePath
@onready var currency_rewards_label = get_node(currency_rewards_label_path)

func set_quest(quest : Quest):
	item_rewards_container.clear_items()
	item_rewards_container.load_items(quest.get_rewards())
	var currency_rewards : Currencies = quest.get_currency_rewards()
	if currency_rewards:
		currency_rewards_label.text = currency_rewards.print_to_string()
	else:
		currency_rewards_label.text = "0 gp"
