extends Node

@export var item_name : String

func _ready():
	var item_data = ItemDatabase.item_data_by_name[item_name]
	if item_data:
		var item = Item.new(item_data)
		get_parent().add_child.call_deferred(item)
		queue_free.call_deferred()
	else:
		push_error("Could not load item by name: " + item_name)
