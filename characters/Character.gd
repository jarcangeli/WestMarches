extends ItemContainer
class_name Character

@export var character_name : String

@export var level : int = 1

var equip_slots : Dictionary

var debt : int = 0

func _ready():
	equip_best_gear() #TODO: Remove from _ready

func get_loaned_items():
	var items = []
	for node in get_children():
		if node is Item and node.loaned_character == self:
			items.append(node)
	return items

func equip_best_gear():
	var items = get_items()
	for item : Item in items:
		if not equip_slots.has(item.primary_slot_type):
			equip_slots[item.primary_slot_type] = item
		else:
			if equip_slots.get(item.primary_slot_type).get_value() < item.get_value():
				equip_slots[item.primary_slot_type] = item

func get_equipped_item(slot : Item.Slot):
	var item = equip_slots.get(slot)
	if item == null or item.get_parent() != self:
		return null
	return item
