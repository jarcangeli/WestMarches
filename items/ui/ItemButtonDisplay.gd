extends ItemDisplay
class_name ItemButtonDisplay

@export var icon : TextureRect
@export var name_label : Label
@export var slot_label : Label
@export var item_icon: ItemIcon

const EQUIPPED_COLOUR = "#bbbbbb"
const UNEQUIPPED_COLOUR = "#ffffff"

var mouse_over : bool = false

func _ready():
	$Button.drag_enabled = drag_enabled
	$Button.disabled = not select_enabled
	$Button.focus_mode = FocusMode.FOCUS_ALL if select_enabled else FocusMode.FOCUS_NONE
	item_icon.select_enabled = select_enabled
	item_icon.drag_enabled = drag_enabled

func refresh_display():
	item_icon.set_item(item)
	if not is_instance_valid(item):
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
	super.set_item(new_item)
	$Button.drag_enabled = drag_enabled and (item.loaned_character == null)

func set_selected(_selected):
	if not select_enabled:
		return
	super.set_selected(_selected)
	$Button.button_pressed = _selected

func on_button_pressed():
	item_selected.emit()
