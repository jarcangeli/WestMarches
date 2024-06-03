extends Node
class_name QuestStep

var quest : Quest = null 
var party : AdventuringParty = null

func start(_quest : Quest, _party : AdventuringParty):
	quest = _quest
	party = _party
	assert(is_instance_valid(quest), "Invalid quest on quest step start")
	assert(is_instance_valid(party), "Invalid party on quest step start")

func advance_step(_party : AdventuringParty):
	print("Default quest step advanced")

func finished():
	return true
