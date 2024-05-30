extends Panel

export var item_rewards_container_path : NodePath
onready var item_rewards_container = get_node(item_rewards_container_path)

func set_quest(quest : Quest):
	item_rewards_container.clear_items()
	item_rewards_container.load_items(quest.get_rewards())
