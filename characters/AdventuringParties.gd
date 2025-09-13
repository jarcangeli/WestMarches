extends Node
class_name AdventuringParties

signal party_added(party : AdventuringParty)

@export var pending_adventuring_parties : AdventuringParties = null

func advance_time():
	if pending_adventuring_parties:
		for party in pending_adventuring_parties.get_children():
			if party is AdventuringParty and party.first_day <= Globals.day:
				pending_adventuring_parties.remove_child(party)
				add_child(party)
				party_added.emit(party)

func get_next_idle_party() -> AdventuringParty:
	for node in get_children():
		if not node is AdventuringParty:
			continue
		#TODO: Check idle
		return node
	return null

func get_idle_parties() -> Array[AdventuringParty]:
	var parties : Array[AdventuringParty] = []
	for node in get_children():
		if node is AdventuringParty and node.quest == null:
			parties.append(node)
	return parties
