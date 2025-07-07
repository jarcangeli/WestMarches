extends Control

func set_character(character):
	$NameLabel.text = character.character_name
	$HBoxContainer/LevelLabel.text = str(character.level)
