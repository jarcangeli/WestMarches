extends QuestStep
class_name QuestStepTravel

var origin = null
var destination = null

func initialise(_origin, _destination):
	origin = _origin
	destination = _destination

func advance_step(_party : AdventuringParty):
	print("Travel quest step advanced")

func finished():
	if ( 	not is_instance_valid(party) or 
			not is_instance_valid(quest) or 
			not is_instance_valid(destination) ) :
		return true
	return party.get_position() == destination
