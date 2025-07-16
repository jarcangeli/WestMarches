extends Panel

@export var quest_name_label: Label
@export var quest_description_text: Label 
@export var quest_progress_text: TextEdit

func set_quest(quest : Quest):
	if not quest:
		quest_name_label.text = ""
		quest_description_text.text = ""
		quest_progress_text.text = ""
		return
	
	quest_name_label.text = quest.quest_name
	quest_description_text.text = quest.quest_description
	quest_progress_text.text = quest.get_progess_text()
