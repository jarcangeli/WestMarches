extends Control
class_name PartySummaryUI

@export var character_summary_scene : Resource
@export var scroll_areas_enabled := true

@onready var character_summaries = %CharacterSummaries
@onready var coins_label: Label = %CoinsLabel
@onready var power_label: Label = %PowerLabel

var party : AdventuringParty = null

func _ready() -> void:
	SignalBus.quest_started.connect(refresh_party)
	SignalBus.quest_finished.connect(refresh_party)
	SignalBus.quest_completed.connect(refresh_party)

func advance_time():
	refresh_party()

func clear_party():
	for node in character_summaries.get_children():
		node.queue_free()

func refresh_party(_dummy = null):
	set_party(party)

func set_party(new_party : AdventuringParty):
	party = new_party
	clear_party()
	if party == null:
		return
	
	add_horizontal_line()
	for character in party.get_characters():
		var character_summary = character_summary_scene.instantiate()
		character_summaries.add_child(character_summary)
		character_summary.set_character(character)
		character_summary.set_scroll_enabled(scroll_areas_enabled)
		add_horizontal_line()
	
	%NameLabel.text = party.display_name
	%LevelBar.value = party.get_average_level() / 300 * 5
	coins_label.text = str(party.get_gold())
	power_label.text = str(party.get_power_level())

func add_vertical_line():
	var panel = Panel.new()
	panel.custom_minimum_size.x = 4
	character_summaries.add_child(panel)

func add_horizontal_line():
	var panel = Panel.new()
	panel.custom_minimum_size.y = 4
	character_summaries.add_child(panel)
