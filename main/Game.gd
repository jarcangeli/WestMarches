extends Control
class_name Game

@onready var advance_time_button: Button = %AdvanceTimeButton
@onready var adventuring_parties: AdventuringParties = %AdventuringParties
@onready var game_over_screen: CenterContainer = %GameOverScreen

var game_over := false

func _ready():
	if Globals.game and Globals.game != self:
		Globals.game.queue_free()
		Globals.game = null
	Globals.game = self
	advance_time_button.advance_time.call_deferred()
	SignalBus.quest_completed.connect(check_if_lost)

func check_if_lost(_quest : Quest):
	for party in adventuring_parties.get_children():
		if party is AdventuringParty and party.is_alive():
			return # not lost yet!
	# No more adventuring parties, game over
	game_over_screen.visible = true
