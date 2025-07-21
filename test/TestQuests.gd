extends Control

@onready var party_1: AdventuringParty = $AdventuringParties/Party1
@onready var advance_time_button: Button = %AdvanceTimeButton
@onready var quest_screen: MarginContainer = $QuestScreen

var count := 0

func _ready():
	iterate.call_deferred()

func iterate():
	count += 1
	party_1.quest = null
	advance_time_button.advance_time()
	if count < 100:
		iterate.call_deferred()
	else:
		quest_screen.open_quest_select_ui()
