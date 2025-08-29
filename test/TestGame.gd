extends Control

@onready var advance_time_button: Button = %AdvanceTimeButton

func _ready():
	if Globals.game and Globals.game != self:
		Globals.game.queue_free()
	Globals.game = self
	advance_time_button.advance_time.call_deferred()
	if TK.DEBUG:
		debug_generate.call_deferred()

func debug_generate():
	advance_time_button.advance_time.call_deferred()
	debug_advance.call_deferred()

func debug_advance():
	$QuestManager.auto_play_quest()
