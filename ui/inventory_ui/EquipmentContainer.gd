extends Control
class_name EquipmentContainer

@export var slot : Item.Slot # (Item.Slot)

var item : Item = null
var item_view = null

func _ready():
	if slot >= 0 and slot < len(Item.slot_container_icons):
		$Background.texture = Item.slot_container_icons[slot]
	
	SignalBus.item_equipped.connect(self.on_item_equipped)

func _can_drop_data(_position, data):
	if not (data is Item):
		return false
	return data.primary_slot_type == slot

func _drop_data(_position, data):
	if not (data is Item):
		push_error("Tried to drop non-item on equipment container")
		return
	print("Dropped item " + data.item_name)
	item = data
	SignalBus.item_equipped.emit(item, self)
	update_item_view()

func remove_item():
	remove_item_view()
	$ItemBackground.visible = false
	SignalBus.item_unequipped.emit(item, self)
	item = null

func remove_item_view():
	if is_instance_valid(item_view):
		item_view.queue_free()
		item_view = null

func update_item_view():
	remove_item_view()
	
	item_view = Item.make_item_preview(item)
	add_child(item_view)
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
