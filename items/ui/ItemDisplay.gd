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
	var margin = -8.0 if hovered else 0.0
	z_index = int(-margin)
	
	# Tween margins
	var tween_speed = 0.2 if hovered else 0.4
	var tween1 = get_tree().create_tween()
	tween1.tween_property(self, "theme_override_constants/margin_left", margin, tween_speed)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "theme_override_constants/margin_right", margin, tween_speed)
	var tween3 = get_tree().create_tween()
	tween3.tween_property(self, "theme_override_constants/margin_top", margin, tween_speed)
	var tween4 = get_tree().create_tween()
	tween4.tween_property(self, "theme_override_constants/margin_bottom", margin, tween_speed)
