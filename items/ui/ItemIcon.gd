extends Control
class_name ItemIcon

signal item_selected()

@export var drag_enabled : bool = true
@export var select_enabled : bool = true
@export var tooltip_enabled : bool = true
@export var hover_select_enabled : bool = false
@export var show_loaned_overlay : bool = true

@onready var background_texture: TextureRect = %BackgroundTexture
@onready var border_texture: TextureRect = %BorderTexture
@onready var slot_texture: TextureRect = %SlotTexture
@onready var icon_texture: TextureRect = %IconTexture
@onready var texture_container: MarginContainer = %TextureContainer
@onready var loaned_texture: TextureRect = %LoanedTexture

var item : Item = null: get = get_item, set = set_item
var selected := false
var hovered = false
var tooltip : ItemTooltip = null
var tween_container = null

const tooltip_scene := preload("res://items/ui/ItemTooltip.tscn")
const anim_speed = 4.0

const border_base_texture = preload("res://assets/icons/border.png")
const anim_border_textures = [border_base_texture, preload("res://assets/icons/border_inner.png"), preload("res://assets/icons/border_outer.png")]

const background_textures := [
	preload("res://assets/icons/backgrounds/background.png"),
	preload("res://assets/icons/backgrounds/background_checked.png"),
	preload("res://assets/icons/backgrounds/background_checked_lower.png"),
	preload("res://assets/icons/backgrounds/background_checked_upper.png"),
	preload("res://assets/icons/backgrounds/background_rings.png"),
	preload("res://assets/icons/backgrounds/background_spots.png"),
	preload("res://assets/icons/backgrounds/background_spots_negative.png")
]

func _ready():
	refresh_display()
	SignalBus.item_consumed.connect(on_item_consumed)
	tween_container = texture_container
	slot_texture.modulate = Globals.slot_colour

func randomize_background_texture():
	var i = (item.id % (len(background_textures) - 1)) + 1 if item else 0
	background_texture.texture = background_textures[i]

#TODO: Scuffed Texture2D animation
var elapsed_time := 0.0
func _process(delta: float) -> void:
	elapsed_time = elapsed_time + delta * anim_speed #TODO: This has to be awful perf
	if hovered:
		border_texture.texture = anim_border_textures[roundi(elapsed_time) % len(anim_border_textures)]
	else:
		border_texture.texture = border_base_texture

func refresh_display():
	if not item:
		return
	icon_texture.texture = item.icon
	slot_texture.texture = Item.slot_mini_icons[item.primary_slot_type]
	var color = Globals.rarity_colours[item.rarity]
	border_texture.modulate = color
	update_background_colour(selected)
	loaned_texture.visible = show_loaned_overlay and item.loaned_character
	randomize_background_texture()

func _get_drag_data(_position):
	if not drag_enabled:
		return null
	var _item = get_item()
	set_drag_preview(Item.make_item_preview(_item))
	print("Picked up " + _item.item_name)
	return self

func set_selected(_selected):
	if not select_enabled:
		return
	
	update_background_colour(_selected)
	
	selected = _selected
	if selected:
		item_selected.emit()
	
	refresh_display.call_deferred()

func update_background_colour(_selected):
	if _selected:
		background_texture.modulate = Globals.background_colour_2
	else:
		background_texture.modulate = Globals.background_colour_1

func set_item(new_item):
	item = new_item
	refresh_display()

func get_item():
	return item

func on_other_item_selected(other_item):
	if item != other_item:
		set_selected(false)

func on_item_consumed(consumed_item : Item):
	if item and consumed_item == item:
		queue_free()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index in [1, 2, 3]:
		set_selected(!selected)

func on_mouse_entered():
	set_hovered(true)
	if select_enabled and hover_select_enabled and not selected:
		set_selected(true)
	AudioBus.play.emit(AudioBus.object_interact)

func on_mouse_excited():
	set_hovered(false)

func set_hovered(_hovered):
	if not _hovered:
		if tooltip:
			tooltip.queue_free()
	elif _hovered and not hovered:
		show_tooltip()
	
	hovered = _hovered

	
	if TK.ENABLE_ITEM_ICON_TWEEN and tween_container and not is_queued_for_deletion():
		# Tween margins
		var margin = -8.0 if hovered else 0.0
		tween_container.z_index = int(-margin)
		
		var tween_speed = 0.2 if hovered else 0.4
		var tween1 = get_tree().create_tween()
		tween1.tween_property(tween_container, "theme_override_constants/margin_left", margin, tween_speed)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(tween_container, "theme_override_constants/margin_right", margin, tween_speed)
		var tween3 = get_tree().create_tween()
		tween3.tween_property(tween_container, "theme_override_constants/margin_top", margin, tween_speed)
		var tween4 = get_tree().create_tween()
		tween4.tween_property(tween_container, "theme_override_constants/margin_bottom", margin, tween_speed)

func show_tooltip():
	if not tooltip_enabled:
		return
	if tooltip:
		tooltip.queue_free()
	tooltip = tooltip_scene.instantiate()
	Globals.game.add_child(tooltip)
	tooltip.set_item(item)
	var tooltip_pos = get_global_rect().position + Vector2(-4, get_global_rect().size[1] + 7.0)
	tooltip.set_position(tooltip_pos)
