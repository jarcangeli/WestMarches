extends Node
class_name QuestSchema

var quest_base = preload("res://quest/QuestBase.tscn")

func generate_quest(_map):
	return null

func get_poi(map):
	# HACK: map should expose an API
	for node in map.get_children():
		if node is POI:
			return node
		else:
			var poi = get_poi(node)
			if poi is POI:
				return poi
	return null

func get_monster(map):
	# HACK: map should expose an API
	for node in map.get_children():
		if node is POI:
			return node
		else:
			var poi = get_poi(node)
			if poi is POI:
				return poi
	return null

func add_step_to_quest(quest, step):
	var steps = quest.get_node("QuestSteps")
	if not is_instance_valid(steps):
		push_warning("Couldnt add step to quests")
		return
	steps.add_child(step)

func add_reward_to_quest(quest, reward):
	var rewards = quest.get_node("Rewards")
	if not is_instance_valid(rewards):
		push_warning("Couldnt add reward to quests")
		return
	rewards.add_child(reward)
