extends Button

func _ready():
	var err = connect("pressed", Callable(self, "advance_time"))
	if err:
		push_error(err)

func advance_time():
	get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFAULT, "time", "advance_time")
	SignalBus.time_advanced.emit()
