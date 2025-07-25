extends MarginContainer

@export var adventuring_parties : Node
@export var party_ui_scene : PackedScene

@onready var party_container: TabContainer = $PartyContainer

func _ready():
	visibility_changed.connect(on_made_visible)

func on_made_visible():
	if not visible:
		return
	
	clear_parties()
	for party in adventuring_parties.get_children():
		add_party(party)

func clear_parties():
	for child in party_container.get_children():
		party_container.remove_child(child)
		child.queue_free()

func add_party(party : AdventuringParty):
	var party_ui = party_ui_scene.instantiate()
	party_container.add_child(party_ui)
	party_ui.name = party.display_name
	party_ui.set_party(party)
