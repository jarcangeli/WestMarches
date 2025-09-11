extends QuestStep
class_name QuestStepNull

var i = 0

func advance_step():
	i += 1

func finished():
	if not started:
		return false
	return i > 1

func get_progress_text():
	var text = []
	if started:
		var start_text = "The party set out on their quest"
		text.append(start_text)
	if finished():
		text.append("The party reach their destination")
	return text

func get_item_rewards():
	return []
