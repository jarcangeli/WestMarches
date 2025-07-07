extends QuestStep
class_name QuestStepTravel

var origin = null
var destination = null

func initialise(_origin, _destination):
	origin = _origin
	destination = _destination

func advance_step():
	print("Travel quest step advanced")
	party.position = destination.get_position()

func finished():
	if not started:
		return false
	if ( 	not is_instance_valid(party) or 
			not is_instance_valid(quest) or 
			not is_instance_valid(destination) ) :
		push_warning("Invalid quest travel step state, terminating early")
		return true
	return party.get_position() == destination.get_position()
