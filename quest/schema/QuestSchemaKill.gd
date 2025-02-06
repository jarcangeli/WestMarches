extends QuestSchema

func generate_quest(map):
	
	var quest : Quest = quest_base.instance()
	
	var monster = get_monster(map)
	if not is_instance_valid(monster):
		push_error("Could not find monster to create kill quest")
		return null
	
	quest.quest_name = "Kill " + monster.name
	quest.quest_description = "A quest to kill " + monster.name

	
	var travel_step := QuestStepTravel.new()
	travel_step.initialise(map.town, monster)
	add_step_to_quest(quest, travel_step)
	
	var battle_step := QuestStepBattle.new()
	battle_step.initialise([monster])
	add_step_to_quest(quest, battle_step)
	
	var return_step := QuestStepTravel.new()
	return_step.initialise(monster, map.town)
	add_step_to_quest(quest, return_step)
	
	return quest
