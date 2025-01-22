extends QuestSchema

func generate_quest(map):
	
	var quest : Quest = quest_base.instance()
	quest.quest_name = "Test Kill"
	quest.quest_description = "Randomly generated description"
	
	var poi = get_poi(map) #TODO: Replace POI with monster
	if not is_instance_valid(poi):
		push_error("Could not find POI to create kill quest")
		return null
	
	var travel_step := QuestStepTravel.new()
	travel_step.initialise(map.town, poi)
	add_step_to_quest(quest, travel_step)
	
	var battle_step := QuestStepBattle.new()
	battle_step.initialise([poi])
	add_step_to_quest(quest, battle_step)
	
	var return_step := QuestStepTravel.new()
	return_step.initialise(poi, map.town)
	add_step_to_quest(quest, return_step)
	
	return quest
