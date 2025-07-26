extends Node
class_name LazyLoadItem

@export var item_name : String

func _ready():
	if item_name == name:
		name = "[TEMP] " + name
	run(item_name, get_parent())
	queue_free.call_deferred()

static func run(_name, parent):
	var item_data = ItemDatabase.get_data_by_name(_name)
	if item_data:
		var item = Item.new(item_data)
		parent.add_child.call_deferred(item, true)
	else:
		push_error("Could not load item by name: " + _name)
