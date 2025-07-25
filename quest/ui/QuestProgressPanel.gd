extends Panel

@export var quest_name_label: Label
@export var quest_description_text: Label 
@export var quest_story_text: TextEdit
@export var quest_combat_log: TextEdit

func set_quest(quest : Quest):
	if not quest:
		quest_name_label.text = ""
		quest_description_text.text = ""
		quest_story_text.text = ""
		quest_combat_log.text = ""
		return
	
	quest_name_label.text = quest.quest_name
	quest_description_text.text = quest.quest_description
	quest_story_text.text = quest.get_progess_text()
	quest_combat_log.text = quest.get_combat_log()
