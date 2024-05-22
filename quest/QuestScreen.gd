extends MarginContainer

export var available_quests_path : NodePath
onready var available_quests = get_node(available_quests_path)

export var active_quests_path : NodePath
onready var active_quests = get_node(active_quests_path)

export var adventuring_parties_path : NodePath
onready var adventuring_parties = get_node(adventuring_parties_path)

export var characters_container_path : NodePath
onready var characters_container = get_node(characters_container_path)

onready var quest_select_ui = $QuestSelectUI
onready var quest_equip_ui = $QuestEquipUI

var current_quest : Quest = null

func _ready():
	quest_select_ui.connect("quest_chosen", self, "on_quest_chosen")
	
	initialise()

func get_available_quests():
	return available_quests.get_children()

func initialise():
	current_quest = null
	quest_select_ui.initialise()
	quest_equip_ui.initialise()
	
	var quests = get_available_quests()
	quest_select_ui.set_quests(quests)
	
	#TODO: extend
	var adventuring_party = adventuring_parties.get_child(0)
	quest_equip_ui.setup_characters(adventuring_party.get_characters())

func on_quest_chosen(quest):
	quest_select_ui.visible = false
	quest_equip_ui.visible = true
	
	current_quest = quest
	quest_equip_ui.on_quest_selected(quest)

func on_start_quest_button_pressed():
	if not is_instance_valid(current_quest):
		initialise()
		return
	
	for character_container in characters_container.get_children():
		var character = character_container.character
		var equipped_items = character_container.get_equipped_items()
		
		for item in equipped_items:
			character.debt += item.get_value()
			item.get_parent().remove_child(item)
			character.add_child(item)
	
	SignalBus.emit_signal("player_inventory_changed")
	current_quest.get_parent().remove_child(current_quest)
	active_quests.add_child(current_quest)
	
	initialise()
