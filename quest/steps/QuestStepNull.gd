extends QuestStep
class_name QuestStepNull

func advance_step():
	pass

func finished():
	return true

func get_progress_text():
	return []

func get_item_rewards():
	return [ItemDatabase.generate_random_item()]
