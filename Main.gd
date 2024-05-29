extends MarginContainer

func advance_time():
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "time", "advance_time")
	SignalBus.emit_signal("time_advanced")

func on_advance_time_button_pressed():
	advance_time()
