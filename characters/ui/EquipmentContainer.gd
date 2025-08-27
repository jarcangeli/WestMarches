extends ItemDropArea
class_name EquipmentContainer

@export var slot : Item.Slot # (Item.Slot)

@onready var item_icon: ItemIcon = %ItemIcon

var item : Item = null
var base_item : Item = null


func _ready():
	item_icon.visible = false
	if slot >= 0 and slot < len(Item.slot_container_icons):
		$Background.texture = Item.slot_container_icons[slot]
	
	SignalBus.item_equipped.connect(self.on_item_equipped)

func set_enabled(enabled):
	drop_enabled = enabled
	$Background.visible = enabled

func _can_drop_data(_position, data):
	if not super._can_drop_data(position, data):
		return false
	return data.get_item().primary_slot_type == slot

func _drop_data(_position, data):
	if not data.has_method("get_item"):
		push_error("Tried to drop something without an item on equipment container")
		return false
	var _item : Item = data.get_item()
	print("Dropped item " + _item.item_name)
	set_item(_item)

func set_item(_item : Item):
	item = _item
	SignalBus.item_equipped.emit(_item, self)
	update_item_view()

func set_base_item(_base_item : Item):
	base_item = _base_item
	update_item_view()

func remove_item():
	if not item:
		return
	$ItemBackground.visible = false
	SignalBus.item_unequipped.emit(item, self)
	item = null
	update_item_view()

func update_item_view():
	item_icon.visible = true
	if item:
		item_icon.set_item(item)
		item_icon.modulate = Color.WHITE
	elif base_item:
		item_icon.set_item(base_item)
		item_icon.modulate = Color.GRAY
	else:
		item_icon.visible = false
	$ItemBackground.visible = true

func on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		remove_item()

func on_item_equipped(other_item, other_slot):
	if other_slot == self:
		return
	if other_item != item:
		return
	remove_item()
