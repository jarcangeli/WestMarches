extends HBoxContainer

signal quest_selected(quest)

func set_quests(_quests):
	pass

func select_quest(quest):
	emit_signal("quest_selected", quest)
