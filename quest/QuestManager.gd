extends Node

@export var parties : AdventuringParties
@export var available_quests : QuestContainerNode

@export var map : Node

var quest_scene = preload("res://quest/QuestKill.tscn")

const MAX_AVAILABLE_QUESTS = 4

 #TODO: Make this more sophisticated, want max 1 active quest per encounter
# e.g. a failed quest could be re-generated
var encounters_already_encountered = []

func _ready():
	SignalBus.quest_completed.connect(on_quest_completed)

func on_quest_completed(quest : Quest):
	var encounter : Encounter = quest.battle_step.encounter
	if encounter and encounter.repeatable:
		encounter.generate_items()
		encounter.generate_monsters()
		var i = encounters_already_encountered.find(encounter)
		if i >= 0:
			encounters_already_encountered.remove_at(i)

func advance_time():
	for party in parties.get_idle_parties():
		print("Generating quest for " + party.display_name)
		generate_quest(party)

func generate_quest(party : AdventuringParty):
	#TODO: Some logic determing level of quest to generate, e.g. always have 2 easy, 1 med, sometimes a rare/hard
	var quest : Quest = generate_quest_kill(party)
	if quest == null:
		#Could not generate a new quest
		#TODO: this should never happen if we generate new monsters
		return
	SignalBus.quest_created.emit(quest)

func generate_quest_kill(party : AdventuringParty):
	var encounter : Encounter = null
	var iterations := 0
	
	while encounter == null and iterations < TK.QUEST_MAX_ITERATIONS:
		encounter = get_encounter(map)
		if not is_instance_valid(encounter):
			print("[TODO] No good encounter found to create kill quest, make some more")
			return null
		var results := CombatSim.simulate(party.get_characters(), encounter.get_monsters(), 100)
		var win_p = results.get_win_percentage()
		if results == null or win_p < TK.QUEST_MIN_PERCENT  or win_p > TK.QUEST_MAX_PERCENT:
			if iterations < TK.QUEST_MAX_ITERATIONS - 1: # Keep last iteration whatever it is
				print("iteration " + str(iterations+1))
				encounter = null
			elif not TK.DEBUG:
				push_warning("Falling back to innapropriate encounter %s for party %s as reached max iterations" % [party.display_name, encounter.encounter_name])
		iterations += 1
	
	var quest : Quest = quest_scene.instantiate()
	add_child(quest)
	quest.initialise(encounter, map)
	quest.party = party
	party.quest = quest #TODO: This is spaghett
	encounters_already_encountered.append(encounter)
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

func get_encounter(root) -> Encounter:
	# HACK: map should expose an API
	var children = root.get_children()
	children.shuffle()
	for node in children:
		if (node is Encounter) and not node in encounters_already_encountered:
			return node
		else:
			var encounter = get_encounter(node)
			if (encounter is Encounter) and not encounter in encounters_already_encountered:
					return encounter
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
	#TODO: Disable
	# Debug tool to set a quest to completed state on startup
	if available_quests.get_child_count() < 1:
		push_warning("No quests to auto-start for debugging")
		return
	var quest : Quest = available_quests.get_child(0)
	quest.start()
	quest.finish()
