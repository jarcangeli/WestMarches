extends Node
class_name Item

signal item_changed()

enum Slot {
	HAND,
	OFFHAND,
	HEAD,
	CHEST
}

const slot_container_icons = [
	preload("res://assets/icons/slots/weapon.png"),
	preload("res://assets/icons/slots/weapon.png"),
	preload("res://assets/icons/slots/head.png"),
	preload("res://assets/icons/slots/chest.png")
]

export var item_name : String = "Name"

export(String, MULTILINE) var description : String = "Placeholder description"

export var icon : Texture

export(Slot) var primary_slot_type

var equip_slot = null

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
	return "-"

static func make_item_preview(item):
	var sprite = TextureRect.new()
	if is_instance_valid(item):
		sprite.texture = item.icon
	return sprite

func _ready():
	#TODO: Does this scale well with every item in the scene?
	SignalBus.hconnect("item_equipped", self, "on_item_equipped")
	SignalBus.hconnect("item_unequipped", self, "on_item_unequipped")

func on_item_equipped(item, slot):
	if item != self:
		if slot == equip_slot:
			equip_slot = null
			emit_signal("item_changed")
	elif equip_slot != slot:
		equip_slot = slot
		emit_signal("item_changed")

func on_item_unequipped(item, slot):
	if item != self:
		return
	if equip_slot == slot:
		equip_slot = null
		emit_signal("item_changed")
