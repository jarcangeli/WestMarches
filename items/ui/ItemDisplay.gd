extends Control
class_name ItemDisplay

signal item_selected()

@export var drag_enabled : bool = true
@export var select_enabled : bool = true

var item : Item = null: get = get_item, set = set_item
var selected := false
var hovered = false

func _ready():
	refresh_display()
	SignalBus.item_consumed.connect(on_item_consumed)

func refresh_display():
	pass

func set_item(new_item):
	item = new_item
	refresh_display()

func get_item():
	return item

func set_selected(_selected):
	if not select_enabled:
		return
	selected = _selected
	if selected:
		item_selected.emit()

func on_other_item_selected(other_item):
	if item != other_item:
		set_selected(false)

func on_item_consumed(consumed_item : Item):
	if item and consumed_item == item:
		queue_free()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		set_selected(!selected)

func on_mouse_entered():
	set_hovered(true)
	if select_enabled and not selected:
		set_selected(true)
	AudioBus.play.emit(AudioBus.object_interact)

func on_mouse_excited():
	set_hovered(false)

func set_hovered(_hovered):
	hovered = _hovered
	var margin = -8 if hovered else 0
	#TODO: Tween in and out
	add_theme_constant_override("margin_left", margin)
	add_theme_constant_override("margin_right", margin)
	add_theme_constant_override("margin_top", margin)
	add_theme_constant_override("margin_bottom", margin)
	z_index = -margin
