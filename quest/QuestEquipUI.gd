extends HBoxContainer

export var character_equip_ui_scene : Resource

export var character_container_path : NodePath
onready var character_container = get_node(character_container_path)

func on_quest_selected(quest):
	setup_characters(quest.get_characters())

func setup_characters(characters):
	for node in character_container.get_children():
		#TODO: Unequip items?
		node.queue_free()
	
	for character in characters:
		var char_ui = character_equip_ui_scene.instance()
		char_ui.call_deferred("set_character", character)
		char_ui.name = character.character_name #TODO: Does this handle repeat names
		character_container.add_child(char_ui)
