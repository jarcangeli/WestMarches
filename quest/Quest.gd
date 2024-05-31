extends Node
class_name Quest

export var quest_name : String
export(String, MULTILINE) var quest_description : String

export var target_path : NodePath
onready var target = get_node(target_path)

onready var steps = $QuestSteps
onready var rewards = $Rewards

var started = false		# set out
var finished = false 	# back in town
var completed = false 	# got rewards

func _ready():
	add_to_group("time")

func start():
	started = true
	SignalBus.emit_signal("quest_started", self)

func complete():
	if completed:
		push_warning("Completing already completed quest")
	completed = true
	if is_instance_valid(Globals.player_inventory):
		Globals.player_inventory.add_rewards(self)
	var currency_rewards = get_currency_rewards()
	if is_instance_valid(Globals.player_currencies) and is_instance_valid(currency_rewards):
		Globals.player_currencies.add_currencies(currency_rewards)
	SignalBus.emit_signal("quest_completed", self)

func advance_time():
	steps.advance_time()

func active():
	return started and not finished

func get_rewards():
	return rewards.get_children()

func get_currency_rewards():
	var return_currencies = null
	for node in rewards.get_children():
		if node is Currencies:
			if return_currencies != null:
				push_warning("Multiple currencies rewards from quest, discarded")
				continue
			return_currencies = node
	return return_currencies
