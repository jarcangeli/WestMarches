extends Node
class_name AdventuringParties

func advance_time():
	pass #TODO: Generate parties

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
