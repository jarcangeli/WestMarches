extends Node
class_name Quest
# kill quest

@export var quest_name : String
@export var quest_description : String # (String, MULTILINE)

@export var target_path : NodePath
@onready var target = get_node_or_null(target_path)

@onready var steps = $QuestSteps
@onready var travel_step = $QuestSteps/TravelStep
@onready var battle_step = $QuestSteps/BattleStep
@onready var return_step = $QuestSteps/ReturnStep
@onready var rewards = $Rewards

var started = false		# set out
var finished = false 	# back in town
var completed = false 	# got rewards

var party : AdventuringParty = null

func _ready():
	add_to_group("time")

func initialise(monster, map):
	quest_name = "Kill " + monster.name
	quest_description = "A quest to kill " + monster.name
	
	travel_step.initialise(map.town, monster)
	battle_step.initialise([monster])
	return_step.initialise(monster, map.town)
	
	$Rewards/CurrencyReward.gold = ceil(get_difficulty())
	
	monster.active_quest = self

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
	if is_instance_valid(Globals.player_inventory):
		Globals.player_inventory.add_rewards(self)
	var currency_rewards = get_currency_rewards()
	if is_instance_valid(Globals.player_currencies) and is_instance_valid(currency_rewards):
		Globals.player_currencies.add_currencies(currency_rewards)
	SignalBus.quest_completed.emit(self)

func advance_time():
	steps.advance_time()

func active():
	return started and not finished

func get_difficulty():
	if battle_step == null:
		return 0
	
	var monsters : Array = battle_step.monsters
	var difficulty_sum = 0
	for monster in monsters:
		difficulty_sum += monster.level
	return difficulty_sum / 20.0 * 5

func get_rewards():
	return rewards.get_children()

func add_rewards(items : Array):
	for item in items:
		if item.get_parent():
			item.get_parent().remove_child(item)
		rewards.add_child(item)

func get_currency_rewards():
	var return_currencies = null
	for node in rewards.get_children():
		if node is Currencies:
			if return_currencies != null:
				push_warning("Multiple currencies rewards from quest, discarded")
				continue
			return_currencies = node
	return return_currencies
