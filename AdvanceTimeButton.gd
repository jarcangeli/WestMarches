extends Button

func _ready():
	var err = connect("pressed", self, "advance_time")
	if err:
		push_error(err)

func advance_time():
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "time", "advance_time")
	SignalBus.emit_signal("time_advanced")
