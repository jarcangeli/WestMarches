extends Node
class_name Item

signal item_changed()

enum Slot {
	HAND,
	OFFHAND,
	HEAD,
	CHEST,
	NONE
}

const slot_container_icons = [
	preload("res://assets/icons/slots/weapon.png"),
	preload("res://assets/icons/slots/weapon.png"),
	preload("res://assets/icons/slots/head.png"),
	preload("res://assets/icons/slots/chest.png"),
	preload("res://assets/icons/icon.png")
]

@export var item_name : String = "Name"

@export var description : String = "Placeholder description" # (String, MULTILINE)

@export var icon : Texture2D

@export var primary_slot_type: Slot

@export var consumed_on_acquire : bool = false

var base_value = 1

var equip_slot = null

var loaned_character = null

static func slot_to_shortname(slot):
	match slot:
		Slot.HAND:
			return "W"
		Slot.OFFHAND:
			return "O"
		Slot.HEAD:
			return "H"
		Slot.CHEST:
			return "C"
	return ""

static func make_item_preview(item):
	var sprite = TextureRect.new()
	if is_instance_valid(item):
		sprite.texture = item.icon
	return sprite

func _ready():
	#TODO: Does this scale well with every item in the scene?
	SignalBus.item_equipped.connect(self.on_item_equipped)
	SignalBus.item_unequipped.connect(self.on_item_unequipped)

func on_item_equipped(item, slot):
	if item != self:
		if slot == equip_slot:
			equip_slot = null
			item_changed.emit()
	elif equip_slot != slot:
		equip_slot = slot
		item_changed.emit()

func on_item_unequipped(item, slot):
	if item != self:
		return
	if equip_slot == slot:
		equip_slot = null
		item_changed.emit()

func get_value():
	#TODO: Calculate from attributes?
	return base_value

func get_currency_granted():
	if consumed_on_acquire:
		# Return first currency
		for node in get_children():
			if node is Currencies:
				return node
	return null
