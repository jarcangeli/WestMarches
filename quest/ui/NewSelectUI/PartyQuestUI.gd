extends Container
class_name PartyQuestUI

@export var quest_select_panel_container : Container

var party : AdventuringParty = null

func set_party(new_party : AdventuringParty):
	if party == new_party:
		return
	
	party = new_party
	for node in quest_select_panel_container.get_children():
		if node is QuestSelectPanel:
			var quest = generate_quest()
			node.set_party(party)
			node.set_quest(quest)
	update_tab_title()

func generate_quest() -> Quest:
	if not Globals.quest_manager:
		return null
	return Globals.quest_manager.generate_quest(party)

func update_tab_title():
	var tab_parent = get_parent() as TabContainer
	if tab_parent:
		var i = tab_parent.get_tab_idx_from_control(self)
		if i >= 0:
			var tab_title = party.display_name if party else "Party %d" % (i+1)
			tab_parent.set_tab_title(i, tab_title)
