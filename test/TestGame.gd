extends Node

@onready var advance_time_button: Button = %AdvanceTimeButton

func _ready():
	debug_generate.call_deferred()

func debug_generate():
	advance_time_button.advance_time()
	debug_advance.call_deferred()

func debug_advance():
	$QuestManager.auto_play_quest()
