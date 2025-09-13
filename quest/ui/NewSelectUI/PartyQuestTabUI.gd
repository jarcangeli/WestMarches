extends Container

@export var adventuring_parties : AdventuringParties
@export var party_quest_ui_scene : PackedScene

@onready var party_quest_ui_container: TabContainer = %PartyQuestUIContainer
@onready var temp_panel: Panel = %TempPanel

func _ready():
	temp_panel.visible = not TK.DEBUG
	
	for node in party_quest_ui_container.get_children():
		node.queue_free()
	
	for node in adventuring_parties.get_children():
		if node is AdventuringParty:
			add_party(node)
	adventuring_parties.party_added.connect(add_party)
	deselect_all()
	
	party_quest_ui_container.tab_selected.connect(on_tab_selected)

func on_tab_selected(_i : int):
	temp_panel.visible = false

func add_party(party : AdventuringParty):
	if not party or not party.is_alive():
		push_warning("Trying to add dead party to quest UI")
		return
	var party_quest_ui : PartyQuestUI = party_quest_ui_scene.instantiate()
	party_quest_ui_container.add_child(party_quest_ui)
	party_quest_ui.set_party.call_deferred(party)

func deselect_all():
	party_quest_ui_container.current_tab = -1
