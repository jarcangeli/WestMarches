extends Label

export var time_tracker_path : NodePath
onready var time_tracker = get_node(time_tracker_path)

func _ready():
	SignalBus.hconnect("time_advanced", self, "update_ui")
	update_ui()

func update_ui():
	text = "Day " + str(time_tracker.day)
