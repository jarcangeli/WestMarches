extends QuestStep
class_name QuestStepBattle

var monsters : Array

func initialise(_monsters):
	monsters = _monsters

func advance_step(_party : AdventuringParty):
	print("Battle quest step advanced")

func finished():
	if not started:
		return false
	if ( 	not is_instance_valid(party) or 
			not is_instance_valid(quest) ) :
		push_warning("Invalid quest travel step state, terminating early")
		return true
	return true # TODO: Implement
