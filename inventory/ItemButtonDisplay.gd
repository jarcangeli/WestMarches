extends Control
class_name ItemButtonDisplay

signal item_selected()

export var icon_path : NodePath
export var name_label_path : NodePath
export var slot_label_path : NodePath
export var drag_enabled : bool = true

onready var icon = get_node(icon_path)
onready var name_label = get_node(name_label_path)
onready var slot_label = get_node(slot_label_path)

const EQUIPPED_COLOUR = "#bbbbbb"
const UNEQUIPPED_COLOUR = "#ffffff"

var item : Item = null setget set_item, get_item
var mouse_over : bool = false

func _ready():
	refresh_display()
	$Button.drag_enabled = drag_enabled

func refresh_display():
	if not is_instance_valid(item):
		icon.texture = null
		name_label.text = "-"
		slot_label.text = "-"
	else:
		icon.texture = item.icon
		name_label.text = item.item_name
		slot_label.text = Item.slot_to_shortname(item.primary_slot_type)
		hint_tooltip = item.description
		if item.equip_slot == null:
			modulate = UNEQUIPPED_COLOUR
		else:
			modulate = EQUIPPED_COLOUR

func set_item(new_item):
	item = new_item
	refresh_display()

func get_item():
	return item

func on_item_changed():
	refresh_display()

func on_other_item_selected(other_item):
	if item != other_item:
		$Button.pressed = false

func on_button_pressed():
	emit_signal("item_selected")
