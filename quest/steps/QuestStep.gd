extends Node
class_name QuestStep

var quest : Quest = null 
var party : AdventuringParty = null

var started : bool = false

func start(_quest : Quest, _party : AdventuringParty):
	started = true
	quest = _quest
	party = _party
	assert(is_instance_valid(quest), "Invalid quest on quest step start")
	assert(is_instance_valid(party), "Invalid party on quest step start")

func advance_step():
	print("Default quest step advanced")

func finished():
	return true
