extends Control
class_name ItemInventoryDisplay

var item : Item = null setget set_item, get_item

export var icon_path : NodePath
export var name_label_path : NodePath
export var slot_label_path : NodePath

onready var icon = get_node(icon_path)
onready var name_label = get_node(name_label_path)
onready var slot_label = get_node(slot_label_path)

func _ready():
	refresh_display()

func refresh_display():
	if not is_instance_valid(item):
		icon.texture = null
		name_label.text = "-"
		slot_label.text = "-"
	else:
		icon.texture = item.icon
		name_label.text = item.item_name
		slot_label.text = Item.slot_to_shortname(item.primary_slot)
		hint_tooltip = item.description

func set_item(new_item):
	item = new_item
	refresh_display()

func get_item():
	return item
