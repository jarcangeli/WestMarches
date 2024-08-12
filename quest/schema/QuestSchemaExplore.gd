extends QuestSchema


func generate_quest(map):
	
	var quest : Quest = quest_base.instance()
	quest.quest_name = "Test"
	quest.quest_description = "Randomly generated description"
	
	var poi = get_poi(map)
	if not is_instance_valid(poi):
		push_error("Could not find POI to create travel quest")
		return null
	
	var travel_step := QuestStepTravel.new()
	travel_step.initialise(map.town, poi)
	add_step_to_quest(quest, travel_step)
	
	# Placeholder
	var wait_step := QuestStep.new()
	add_step_to_quest(quest, wait_step)
	
	#TODO: Encounter steps? Fight/loot/map
	
	var return_step := QuestStepTravel.new()
	return_step.initialise(poi, map.town)
	add_step_to_quest(quest, return_step)
	
	return quest
