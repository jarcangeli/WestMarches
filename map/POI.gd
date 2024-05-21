extends Node2D
class_name POI
# Point Of Interest

func get_items():
	var items = []
	for node in get_children():
		if node is Item:
			items.append(node)
	return items

