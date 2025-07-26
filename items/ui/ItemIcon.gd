extends Control
class_name ItemIcon

signal item_selected()

@export var drag_enabled := true
@export var min_size := 32

@onready var background_texture: TextureRect = %BackgroundTexture
@onready var border_texture: TextureRect = %BorderTexture
@onready var slot_texture: TextureRect = %SlotTexture
@onready var icon_texture: TextureRect = %IconTexture

var item : Item = null

const selected_background_color = Color.WEB_GRAY
const background_color = Color.BLACK

func _ready():
	SignalBus.item_consumed.connect(on_item_consumed)

func set_item(_item : Item):
	if not _item:
		return
	item = _item
	icon_texture.texture = item.icon
	slot_texture.texture = Item.slot_mini_icons[item.primary_slot_type]
	var color = Globals.rarity_colours[item.rarity]
	border_texture.modulate = color
	tooltip_text = item.item_name #TODO: More info in tooltip
	background_texture.modulate = background_color

func get_item() -> Item:
	return item

func _get_drag_data(_position):
	if not drag_enabled:
		return null
	var _item = get_item()
	set_drag_preview(Item.make_item_preview(_item))
	print("Picked up " + _item.item_name)
	return self

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		set_selected(true)

func on_item_consumed(consumed_item : Item):
	if item and consumed_item == item:
		queue_free()

func set_selected(selected):
	if selected:
		background_texture.modulate = selected_background_color
	else:
		background_texture.modulate = background_color
	if selected:
		item_selected.emit()
