extends Node

export var parties_path : NodePath
onready var parties = get_node(parties_path)

export var map_path : NodePath
onready var map = get_node(map_path)

onready var quest_schemas = $QuestSchemas

func advance_time():
	print("Generating new quests")
	
	var party = parties.get_next_idle_party()
	while is_instance_valid(party):
		
		generate_quest_for_party(party)
		#TODO: Enable when we get more parties
		#party = parties.get_next_idle_party()
		party = null

func generate_quest_for_party(_party : AdventuringParty):
	#TODO: Use the party to determine appropriate quests
	var schema : QuestSchema = get_random_quest_schema()
	
	var quest : Quest = schema.generate_quest(map)
	#TODO: Somehow track suggested party
	SignalBus.emit_signal("quest_created", quest)

func get_random_quest_schema():
	return quest_schemas.get_children()[0] #HACK
