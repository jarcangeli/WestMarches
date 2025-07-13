extends Node
class_name ItemContainer

signal item_added(item)

func add_item(item : Item):
	if not is_instance_valid(item):
		return
	
	if is_instance_valid(item.get_parent()):
		item.get_parent().remove_child(item)
	
	item_added.emit(item) #TODO: This could cause issues if item is now consumed?
	if item.consumed_on_acquire and self == Globals.player_inventory:
		var currencies = item.get_currency_granted()
		Globals.player_currencies.add_currencies(currencies)
		SignalBus.item_consumed.emit(item)
		item.queue_free()
	else:
		add_child(item)

func add_items(items) -> void:
	for item in items:
		add_item(item)

func get_items() -> Array:
	var items : Array = []
	for child in get_children():
		if child is Item:
			items.append(child)
	return items

func add_rewards(quest : Quest):
	if not is_instance_valid(quest):
		return
	
	for item in quest.get_rewards():
		if item is Item:
			add_item(item)
	
	SignalBus.player_inventory_changed.emit()
