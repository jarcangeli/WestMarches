extends QuestStep
class_name QuestStepTravel

var origin = null
var destination = null

var item_rewards = []

func initialise(_origin, _destination):
	origin = _origin
	destination = _destination
	if randf() < TK.QUEST_TRAVEL_ITEM_CHANCE: #TODO: Conditional on encounter
		item_rewards = [ItemDatabase.generate_random_item()]

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

func get_progress_text():
	var text = []
	if started:
		var start_text = "The party set out"
		if destination:
			start_text +=  " towards " + destination.name
		text.append(start_text)
	if finished():
		text.append("The party reach their destination")
	return text

func get_item_rewards():
	return item_rewards
