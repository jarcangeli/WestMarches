extends VBoxContainer
class_name CharacterEquipUI

@onready var equipment_layout: EquipmentSlotLayout = %EquipmentLayout

var character : Character = null

func set_character(new_character):
	if new_character == null:
		return
	character = new_character
	$CharacterLabel.text = character.character_name
	name = character.character_name
	equipment_layout.set_character(character)

func get_equipped_items():
	return equipment_layout.get_equipped_items()

func return_equipped_items():
	return equipment_layout.return_equipped_items()
