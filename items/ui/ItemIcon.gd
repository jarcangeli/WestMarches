extends ItemDisplay
class_name ItemIcon

@export var min_size := 32

@onready var background_texture: TextureRect = %BackgroundTexture
@onready var border_texture: TextureRect = %BorderTexture
@onready var slot_texture: TextureRect = %SlotTexture
@onready var icon_texture: TextureRect = %IconTexture

const selected_background_color = Color(0.4, 0.4, 0.4)
const background_color = Color(0.2, 0.2, 0.2)

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
	randomize_background_texture()

func randomize_background_texture():
	background_texture.texture = background_textures.pick_random()

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
	tooltip_text = item.item_name #TODO: More info in tooltip
	background_texture.modulate = background_color

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
	if _selected:
		background_texture.modulate = selected_background_color
	else:
		background_texture.modulate = background_color
	super.set_selected(_selected)
