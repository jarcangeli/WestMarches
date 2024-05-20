extends Control

export(Item.Slot) var slot

var item : Item = null

func can_drop_data(_position, data):
	if not (data is Item):
		return false
	return data.primary_slot == slot

func drop_data(_position, data):
	if not (data is Item):
		push_error("Tried to drop non-item on equipment container")
		return
	print("Dropped item " + data.item_name)
	data = item
