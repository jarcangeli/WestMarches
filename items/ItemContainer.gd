extends Node
class_name ItemContainer

signal item_added(item)
#TODO: No item removed signal?

func contains(item : Item) -> bool:
	for node in get_children():
		if node == item:
			return true
	return false #TODO: Optimize? Sorted nodes?

func contains_name(item_name : String) -> bool:
	for node in get_children():
		if node is Item and node.item_name == item_name:
			return true
	return false #TODO: Optimize? Sorted nodes?

func add_item(item : Item):
	if not is_instance_valid(item) or contains(item):
		return
	
	if item.loaned_character:
		item.loaned_character.unequip_item(item)
	if is_instance_valid(item.get_parent()):
		if item.get_parent() is Character:
			item.get_parent().unequip_item(item)
		item.get_parent().remove_child(item)
	
	item_added.emit(item)
	add_child(item, true)

func add_items(items) -> void:
	for item in items:
		add_item(item)

func get_items() -> Array:
	var items : Array = []
	for child in get_children():
		if child is Item:
			items.append(child)
	return items
