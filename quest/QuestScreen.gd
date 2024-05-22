extends MarginContainer

export var available_quests_path : NodePath
onready var available_quests = get_node(available_quests_path)

onready var quest_select_ui = $QuestSelectUI
onready var quest_equip_ui = $QuestEquipUI

var quests = []

func _ready():
	quest_select_ui.visible = true
	quest_equip_ui.visible = false
	
	quest_select_ui.connect("quest_chosen", self, "on_quest_chosen")
	
	quests = generate_quests()
	quest_select_ui.set_quests(quests)

func generate_quests():
	return available_quests.get_children()

func on_quest_chosen(quest):
	quest_select_ui.visible = false
	quest_equip_ui.visible = true
	
	quest_equip_ui.on_quest_selected(quest)
