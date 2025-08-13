extends Control
class_name PartySummaryUI

@export var character_summary_scene : Resource
@export var scroll_areas_enabled := true

@onready var character_summaries = %CharacterSummaries
@onready var coins_label: Label = %CoinsLabel
@onready var power_label: Label = %PowerLabel

func clear_party():
	for node in character_summaries.get_children():
		node.queue_free()

func set_party(party : AdventuringParty):
	clear_party()
	
	for character in party.get_characters():
		var character_summary = character_summary_scene.instantiate()
		character_summaries.add_child(character_summary)
		character_summary.set_character(character)
		character_summary.set_scroll_enabled(scroll_areas_enabled)
	
	%NameLabel.text = party.display_name
	%LevelBar.value = party.get_average_level() / 300 * 5
	coins_label.text = str(party.get_gold())
	power_label.text = str(party.get_power_level())
