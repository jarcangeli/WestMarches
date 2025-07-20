extends Node

@onready var advance_time_button: Button = %AdvanceTimeButton

func _ready():
	debug_advance.call_deferred()

var i := 0
func debug_advance():
	if i == 1:
		$QuestManager.auto_play_quest()
	if i == 5:
		return
	i+=1
	
	advance_time_button.advance_time()
	
	debug_advance.call_deferred()
