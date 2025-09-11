extends Control

@onready var advance_time_button: Button = %AdvanceTimeButton
@onready var adventuring_parties: AdventuringParties = %AdventuringParties
@onready var game_over_screen: CenterContainer = %GameOverScreen

var game_over := false

func _ready():
	if Globals.game and Globals.game != self:
		Globals.game.queue_free()
	Globals.game = self
	advance_time_button.advance_time.call_deferred()
	if TK.DEBUG:
		debug_generate.call_deferred()
	SignalBus.quest_completed.connect(check_if_lost)

func debug_generate():
	advance_time_button.advance_time.call_deferred()
	debug_advance.call_deferred()

func debug_advance():
	$QuestManager.auto_play_quest()

func check_if_lost(_quest : Quest):
	for party in adventuring_parties.get_children():
		if party is AdventuringParty and party.is_alive():
			return # not lost yet!
	# No more adventuring parties, game over
	game_over_screen.visible = true
