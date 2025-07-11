extends Node

@export var parties : AdventuringParties
@export var available_quests : QuestContainerNode

@export var map_path : NodePath
@onready var map = get_node(map_path)

var quest_scene = preload("res://quest/QuestKill.tscn")

const MAX_AVAILABLE_QUESTS = 4

func _ready():
	print("Generating initial quests")
	call_deferred("generate_quest")
	call_deferred("generate_quest")
	call_deferred("auto_play_quest")

func advance_time():
	if available_quests.get_child_count() < MAX_AVAILABLE_QUESTS:
		print("Generating new quests")
		generate_quest()

func generate_quest():
	#TODO: Some logic determing level of quest to generate, e.g. always have 2 easy, 1 med, sometimes a rare/hard
	var quest : Quest = generate_quest_kill()
	if quest == null:
		#Could not generate a new quest
		#TODO: this should never happen if we generate new monsters
		return
	SignalBus.quest_created.emit(quest)

func generate_quest_kill():
	var monster = get_monster(map)
	if not is_instance_valid(monster):
		print("[TODO] No free monster found to create kill quest, make some more")
		return null
	
	var quest : Quest = quest_scene.instantiate()
	add_child(quest)
	quest.initialise(monster, map)
	return quest

func get_poi(root):
	# HACK: map should expose an API
	for node in root.get_children():
		if node is POI:
			return node
		else:
			var poi = get_poi(node)
			if poi is POI:
				return poi
	return null

func get_monster(root):
	# HACK: map should expose an API
	var children = root.get_children()
	children.shuffle()
	for node in children:
		if (node is Monster) and (node.active_quest == null):
			return node
		else:
			var monster = get_monster(node)
			if (monster is Monster) and (monster.active_quest == null):
					return monster
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

func auto_play_quest():
	# Debug tool to set a quest to completed state on startup
	var quest : Quest = available_quests.get_child(0)
	quest.start(parties.get_child(0))
	quest.finish()
