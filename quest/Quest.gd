extends Node
class_name Quest

export var quest_name : String
export(String, MULTILINE) var quest_description : String

export var target_path : NodePath
onready var target = get_node(target_path)

onready var steps = $QuestSteps

var started = false		# set out
var finished = false 	# back in town
var completed = false 	# got rewards

func _ready():
	add_to_group("time")

func start():
	started = true
	SignalBus.emit_signal("quest_started", self)

func advance_time():
	steps.advance_time()

func active():
	return started and not finished
