extends MarginContainer

@export var pending_quests_path : NodePath
@onready var pending_quests = get_node(pending_quests_path)

@export var available_quests_path : NodePath
@onready var available_quests = get_node(available_quests_path)

@export var active_quests_path : NodePath
@onready var active_quests = get_node(active_quests_path)

@export var completed_quests_path : NodePath
@onready var completed_quests = get_node(completed_quests_path)

@export var adventuring_parties_path : NodePath
@onready var adventuring_parties = get_node(adventuring_parties_path)

@export var characters_container_path : NodePath
@onready var characters_container = get_node(characters_container_path)

@onready var quest_select_ui = $QuestSelectUI
@onready var quest_equip_ui = $QuestEquipUI

var current_quest : Quest = null
var current_party : AdventuringParty = null

func _ready():
	quest_select_ui.connect("quest_chosen", Callable(self, "on_quest_chosen"))
	
	SignalBus.quest_created.connect(self.on_quest_changed)
	SignalBus.quest_finished.connect(self.on_quest_changed)
	SignalBus.quest_completed.connect(self.on_quest_changed)
	
	initialise()

func get_pending_quests():
	return pending_quests.get_children()

func get_available_quests():
	return available_quests.get_children()

func get_active_quests():
	return active_quests.get_children()

func get_completed_quests():
	return completed_quests.get_children()

func initialise():
	current_quest = null
	quest_select_ui.initialise()
	quest_equip_ui.initialise()
	
	var _pending_quests = get_pending_quests()
	quest_select_ui.set_pending_quests(_pending_quests)
	
	var _available_quests = get_available_quests()
	quest_select_ui.set_new_quests(_available_quests)
	
	var _active_quests = get_active_quests()
	quest_select_ui.set_active_quests(_active_quests)
	
	var _completed_quests = get_completed_quests()
	quest_select_ui.set_completed_quests(_completed_quests)
	
	
	#TODO: extend to allow multiple adventuring parties
	var adventuring_party = adventuring_parties.get_child(0)
	current_party = adventuring_party
	quest_select_ui.set_party(adventuring_party)

func on_quest_chosen(quest):
	quest_select_ui.visible = false
	quest_equip_ui.visible = true
	
	#HACK: until party selection is finalised just use first available
	quest.party = current_party
	
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
	
	SignalBus.player_inventory_changed.emit()
	current_quest.start(current_party)
	
	initialise()

func on_quest_changed(_quest):
	initialise()
	#TODO: Throttle this to once if multiple finish
