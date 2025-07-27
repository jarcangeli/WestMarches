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

var cached_simulation_results : CombatSimResults = null

func _ready():
	add_to_group("time")

func initialise(encounter : Encounter, map):
	quest_name = encounter.name
	quest_description = encounter.description
	
	travel_step.initialise(map.town, encounter.get_location())
	battle_step.initialise(encounter)
	return_step.initialise(encounter.get_location(), map.town)

func start():
	if not is_instance_valid(party):
		push_error("Quest started with invalid party")
	started = true
	SignalBus.quest_started.emit(self)

func finish():
	finished = true
	SignalBus.quest_finished.emit(self)

func complete():
	if completed:
		push_warning("Completing already completed quest")
	finished = true
	completed = true
	SignalBus.quest_completed.emit(self)

func advance_time():
	steps.advance_time()

func active():
	return started and not finished

func get_progess_text():
	var progress = travel_step.get_progress_text() + battle_step.get_progress_text() + return_step.get_progress_text()
	return "\n".join(progress)

func get_combat_log():
	return "\n".join(battle_step.get_combat_log())

func get_difficulty():
	if not battle_step or not battle_step.encounter:
		return 0
	
	var monsters : Array = battle_step.encounter.get_monsters()
	var difficulty_sum = 0
	for monster in monsters:
		difficulty_sum += monster.get_power_level()
	return difficulty_sum / 300.0 * 5

func simulate_results() -> CombatSimResults:
	if cached_simulation_results:
		return cached_simulation_results
	
	if not battle_step or not battle_step.encounter:
		var fake_results = CombatSimResults.new()
		fake_results.wins = 1
		return fake_results
	if not party:
		return CombatSimResults.new()
	
	var adventurers := party.get_characters()
	var monsters := battle_step.encounter.get_monsters()
	var results : CombatSimResults = CombatSim.simulate(adventurers, monsters, 300)
	cached_simulation_results = results
	return results

func get_rewards():
	var rewards = []
	if battle_step and battle_step.encounter:
		rewards += battle_step.encounter.get_item_rewards()
	if travel_step:
		rewards += travel_step.get_item_rewards()
	if return_step:
		rewards += return_step.get_item_rewards()
	return rewards

func add_rewards(items):
	if not battle_step or not battle_step.encounter:
		return
	return battle_step.encounter.add_item_rewards(items)
