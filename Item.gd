extends Node
class_name Item

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

export(Slot) var primary_slot

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
