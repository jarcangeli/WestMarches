extends Node
class_name Item

enum Slot {
	HAND,
	OFFHAND,
	HEAD,
	CHEST
}

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
