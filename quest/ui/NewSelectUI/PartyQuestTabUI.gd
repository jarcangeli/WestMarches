extends Container

@export var party_quest_ui_scene : PackedScene
@export var debug_party : AdventuringParty
@export var party_quest_ui_container : Container

func _ready():
	for node in party_quest_ui_container.get_children():
		node.queue_free()
	
	if debug_party:
		add_party.call_deferred(debug_party)

func add_party(party : AdventuringParty):
	if not party or not party.is_alive():
		push_warning("Trying to add dead party to quest UI")
		return
	var party_quest_ui : PartyQuestUI = party_quest_ui_scene.instantiate()
	party_quest_ui_container.add_child(party_quest_ui)
	party_quest_ui.set_party.call_deferred(party)
