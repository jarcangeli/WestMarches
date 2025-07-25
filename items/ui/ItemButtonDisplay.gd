extends Control
class_name ItemButtonDisplay

signal item_selected()

@export var icon_path : NodePath
@export var name_label_path : NodePath
@export var slot_label_path : NodePath
@export var drag_enabled : bool = true

@onready var icon = get_node(icon_path)
@onready var name_label = get_node(name_label_path)
@onready var slot_label = get_node(slot_label_path)

const EQUIPPED_COLOUR = "#bbbbbb"
const UNEQUIPPED_COLOUR = "#ffffff"

var item : Item = null: get = get_item, set = set_item
var mouse_over : bool = false

func _ready():
	refresh_display()
	$Button.drag_enabled = drag_enabled
	SignalBus.item_consumed.connect(on_item_consumed)

func refresh_display():
	if not is_instance_valid(item):
		icon.texture = null
		name_label.text = "-"
		slot_label.text = "-"
	else:
		icon.texture = item.icon
		name_label.text = item.item_name
		slot_label.text = Item.slot_to_shortname(item.primary_slot_type)
		tooltip_text = item.description
		if item.equip_slot == null and item.loaned_character == null:
			modulate = UNEQUIPPED_COLOUR
		else:
			modulate = EQUIPPED_COLOUR

func set_item(new_item):
	item = new_item
	$Button.drag_enabled = drag_enabled and (item.loaned_character == null)
	refresh_display()

func get_item():
	return item

func on_item_changed():
	refresh_display()

func on_other_item_selected(other_item):
	if item != other_item:
		$Button.button_pressed = false

func on_button_pressed():
	item_selected.emit()

func on_item_consumed(consumed_item : Item):
	if item and consumed_item == item:
		queue_free()
