extends Node
class_name AdventuringParties

func get_next_idle_party() -> AdventuringParty:
	for node in get_children():
		if not node is AdventuringParty:
			continue
		#TODO: Check idle
		return node
	return null
