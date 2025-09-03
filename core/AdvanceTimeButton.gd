extends Button

func _ready():
	pressed.connect(advance_time)
	if TK.TUTORIAL:
		visible = false
		SignalBus.quest_started.connect(on_first_quest_started, CONNECT_ONE_SHOT)

func on_first_quest_started(_quest):
	visible = true

func advance_time():
	get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFAULT, "time", "advance_time")
	SignalBus.time_advanced.emit()
