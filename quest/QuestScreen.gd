extends MarginContainer

onready var quest_select_ui = $QuestSelectUI
onready var quest_equip_ui = $QuestEquipUI

var quests = []

func _ready():
	quest_select_ui.visible = true
	quest_equip_ui.visible = false
	
	quest_select_ui.connect("quest_selected", self, "on_quest_selected")
	
	quests = generate_quests()
	quest_select_ui.set_quests(quests)

func generate_quests():
	return []

func on_quest_selected(quest):
	quest_select_ui.visible = false
	quest_equip_ui.visible = true
	
	quest_equip_ui.on_quest_selected(quest)
