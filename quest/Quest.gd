extends Node
class_name Quest
# kill quest

@export var quest_name : String
@export var quest_description : String # (String, MULTILINE)

@export var target_path : NodePath
@onready var target = get_node_or_null(target_path)

@onready var steps = $QuestSteps
@onready var travel_step : QuestStepTravel = $QuestSteps/TravelStep
@onready var battle_step : QuestStepBattle = $QuestSteps/BattleStep
@onready var return_step : QuestStepTravel = $QuestSteps/ReturnStep

var started = false		# set out
var finished = false 	# back in town
var completed = false 	# got rewards

var party : AdventuringParty = null

func _ready():
	add_to_group("time")

func initialise(encounter : Encounter, map):
	quest_name = encounter.name
	quest_description = "Insert description here" #TODO: Property of encounter
	
	travel_step.initialise(map.town, encounter.get_location())
	battle_step.initialise(encounter)
	return_step.initialise(encounter.get_location(), map.town)

func start(new_party):
	if not is_instance_valid(new_party):
		push_error("Quest started with invalid party")
	party = new_party
	started = true
	SignalBus.quest_started.emit(self)

func finish():
	finished = true
	SignalBus.quest_finished.emit(self)

func complete():
	if completed:
		push_warning("Completing already completed quest")
	completed = true
	SignalBus.quest_completed.emit(self)

func advance_time():
	steps.advance_time()

func active():
	return started and not finished

func get_progess_text():
	var progress = travel_step.get_progress_text() + battle_step.get_progress_text() + return_step.get_progress_text()
	return "\n".join(progress)

func get_difficulty():
	if not battle_step or not battle_step.encounter:
		return 0
	
	var monsters : Array = battle_step.encounter.get_monsters()
	var difficulty_sum = 0
	for monster in monsters:
		difficulty_sum += monster.get_power_level()
	return difficulty_sum / 300.0 * 5

func simulate_win_percentage(_party : AdventuringParty):
	#TODO: replace with property party
	if not battle_step or not battle_step.encounter:
		return 100
	if not _party:
		return 0
	
	var adventurers := _party.get_characters()
	var monsters := battle_step.encounter.get_monsters()
	var results := CombatSim.simulate(adventurers, monsters, 300)
	return results.get_win_percentage()

func get_rewards():
	if not battle_step or not battle_step.encounter:
		return []
	return battle_step.encounter.get_item_rewards()

func add_rewards(items):
	if not battle_step or not battle_step.encounter:
		return
	return battle_step.encounter.add_item_rewards(items)
