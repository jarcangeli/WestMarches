extends Control

@export var pending_quests : QuestContainerNode
@export var available_quests : QuestContainerNode
@export var active_quests : QuestContainerNode
@export var completed_quests : QuestContainerNode
@export var adventuring_parties : Node

@onready var quest_select_ui: QuestSelectUI = %QuestSelectUI
@onready var quest_equip_ui: QuestEquipUI = %QuestEquipUI
@onready var quest_reward_ui: QuestRewardUI = %QuestRewardUI

@onready var characters_container = quest_equip_ui.characters_container

var current_quest : Quest = null
var current_party : AdventuringParty = null

func _ready():
	quest_select_ui.quest_chosen.connect(on_quest_chosen)
	
	quest_equip_ui.quest_started.connect(open_quest_select_ui)
	quest_equip_ui.quest_abandoned.connect(open_quest_select_ui)
	
	quest_reward_ui.quest_finished.connect(open_quest_select_ui)
	quest_reward_ui.quest_abandoned.connect(open_quest_select_ui)
	
	SignalBus.quest_created.connect(self.on_quest_changed)
	SignalBus.quest_finished.connect(self.on_quest_changed)
	SignalBus.quest_completed.connect(self.on_quest_changed)
	
	open_quest_select_ui()

func get_pending_quests():
	return pending_quests.get_children()

func get_available_quests():
	return available_quests.get_children()

func get_active_quests():
	return active_quests.get_children()

func get_completed_quests():
	return completed_quests.get_children()

func open_quest_select_ui():	
	quest_select_ui.visible = true
	quest_equip_ui.visible = false
	quest_reward_ui.visible = false
	current_quest = null
	
	var _pending_quests = get_pending_quests()
	quest_select_ui.set_pending_quests(_pending_quests)
	
	var _available_quests = get_available_quests()
	quest_select_ui.set_new_quests(_available_quests)
	
	var _active_quests = get_active_quests()
	quest_select_ui.set_active_quests(_active_quests)
	
	var _completed_quests = get_completed_quests()
	quest_select_ui.set_completed_quests(_completed_quests)
	
	#TODO: extend to allow multiple adventuring parties
	var adventuring_party = adventuring_parties.get_child(randi() % adventuring_parties.get_child_count())
	current_party = adventuring_party
	quest_select_ui.set_party(adventuring_party)

func open_quest_equip_ui(quest : Quest):
	quest_select_ui.visible = false
	quest_equip_ui.visible = true
	quest_reward_ui.visible = false
	quest_equip_ui.on_quest_selected(quest)

func open_quest_reward_ui(quest : Quest):
	quest_select_ui.visible = false
	quest_equip_ui.visible = false
	quest_reward_ui.visible = true
	quest_reward_ui.setup_quest_reward_ui(quest)

func on_quest_chosen(quest):
	if quest and not quest.started and not quest.party:
		quest.party = current_party #TODO: Shouldn't be random
	current_quest = quest
	
	if not quest:
		open_quest_select_ui()
	elif not quest.finished:
		open_quest_equip_ui(quest)
	else:
		open_quest_reward_ui(quest)

func on_abandon_quest_button_pressed():
	for character_container in characters_container.get_children():
		character_container.return_equipped_items()
		character_container.queue_free()
	
	open_quest_select_ui()

func on_quest_changed(_quest):
	open_quest_select_ui()
	#TODO: Throttle this to once if multiple finish
