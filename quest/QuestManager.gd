extends Node
class_name QuestManager

@export var parties : AdventuringParties
@export var available_quests : QuestContainerNode

var quest_scene = preload("res://quest/QuestKill.tscn")

const MAX_AVAILABLE_QUESTS = 4

# Track dependencies completed
var encounters_completed = []

func _ready():
	Globals.quest_manager = self
	SignalBus.quest_completed.connect(on_quest_completed)

func on_quest_completed(quest : Quest):
	var encounter : Encounter = quest.battle_step.encounter
	if encounter:
		encounters_completed.append(encounter.encounter_name)
		if encounter.repeatable:
				encounter.generate_items()
				encounter.generate_monsters()

var encounters_this_timestep = []
func advance_time():
	encounters_this_timestep.clear()
	POIDatabase.update_available_encounters(encounters_completed)

func generate_quest(party : AdventuringParty):
	#TODO: Some logic determing level of quest to generate, e.g. always have 2 easy, 1 med, sometimes a rare/hard
	var quest : Quest = generate_quest_kill(party)
	if quest == null:
		push_error("Could not generate a new quest")
		#TODO: this should never happen if we generate new monsters
		return null
	SignalBus.quest_created.emit(quest)
	return quest

func generate_quest_kill(party : AdventuringParty):
	var encounter : Encounter = null
	
	while not party.preset_quests.is_empty() and encounter == null:
		var preset_encounter_name = party.preset_quests[0]
		party.preset_quests.remove_at(0)
		encounter = POIDatabase.encounters_by_name.get(preset_encounter_name, null)
	
	var iterations := 0
	while encounter == null and iterations < TK.quest_max_iterations():
		encounter = get_encounter()
		if not is_instance_valid(encounter):
			push_warning("[TODO] No good encounter found to create kill quest, make some more")
			return null
		var results := CombatSim.simulate(party.get_characters(), encounter.get_monsters(), 100)
		var win_p = results.get_win_percentage()
		if results == null or win_p < TK.QUEST_MIN_PERCENT  or win_p > TK.QUEST_MAX_PERCENT:
			if iterations < TK.quest_max_iterations() - 1: # Keep last iteration whatever it is
				encounter = null
			elif not TK.DEBUG:
				push_warning("Falling back to innapropriate encounter %s for party %s as reached max iterations" % [party.display_name, encounter.encounter_name])
		iterations += 1
	
	var quest : Quest = quest_scene.instantiate()
	add_child(quest)
	quest.initialise(encounter, null)
	quest.party = party
	party.quest = quest #TODO: This is spaghett
	encounters_this_timestep.append(encounter.encounter_name)
	return quest

func get_encounter() -> Encounter:
	const MAX_RETRIES := 100
	var i = 0
	var encounter : Encounter = null
	while i < MAX_RETRIES and encounter == null:
		i += 1
		encounter = POIDatabase.get_random_encounter()
		if encounter.encounter_name in encounters_this_timestep:
			encounter = null
			continue
	return encounter

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
