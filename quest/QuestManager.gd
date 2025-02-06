extends Node

export var parties_path : NodePath
onready var parties = get_node(parties_path)

export var available_quests_path : NodePath
onready var available_quests = get_node(available_quests_path)

export var map_path : NodePath
onready var map = get_node(map_path)

onready var quest_schemas = $QuestSchemas

const MAX_AVAILABLE_QUESTS = 4

func advance_time():
	
	var party = parties.get_next_idle_party()
	while is_instance_valid(party) and available_quests.get_child_count() < MAX_AVAILABLE_QUESTS:
		
		print("Generating new quests")
		generate_quest_for_party(party)
		#TODO: Enable when we get more parties
		#party = parties.get_next_idle_party()
		party = null

func generate_quest_for_party(_party : AdventuringParty):
	#TODO: Use the party to determine appropriate quests
	var schema : QuestSchema = get_random_quest_schema()
	if schema == null:
		push_error("Could not generate quest for party, no schema")
		return
	
	var quest : Quest = schema.generate_quest(map)
	if quest == null:
		push_warning("Could not generate a new quest")
		return
	#TODO: Somehow track suggested party
	SignalBus.emit_signal("quest_created", quest)

func get_random_quest_schema():
	if quest_schemas.get_child_count() == 0:
		push_error("Tried to generate quest with no available schemas")
		return null
	var i = randi() % quest_schemas.get_child_count()
	return quest_schemas.get_children()[i]
