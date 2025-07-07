extends VBoxContainer

@export var character_summary_scene : Resource

@export var party_path : NodePath

@onready var character_summaries = $CharacterSummariesScrollArea/CharacterSummaries

func _ready() -> void:
	var party = get_node(party_path)
	if party:
		set_party(party)

func clear_party():
	for node in character_summaries.get_children():
		node.queue_free()

func set_party(party):
	clear_party()
	
	$NameLabel.text = party.display_name
	$CenterContainer/LevelBar.value = party.get_average_level() / 20 * 5
	
	for character in party.get_characters():
		var character_summary = character_summary_scene.instantiate()
		character_summaries.add_child(character_summary)
		character_summary.set_character(character)
