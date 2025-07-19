extends Node
class_name Item

signal item_changed()

enum Slot {
	HAND,
	OFFHAND,
	HEAD,
	CHEST,
	FEET,
	LEGS,
	ACCESSORY,
	NONE
}

const slot_container_icons = [
	preload("res://assets/icons/slots/weapon.png"),
	preload("res://assets/icons/slots/weapon.png"),
	preload("res://assets/icons/slots/head.png"),
	preload("res://assets/icons/slots/chest.png"),
	preload("res://assets/icons/slots/boot.png"),
	preload("res://assets/icons/slots/legs.png"),
	preload("res://assets/icons/slots/ring.png"),
	preload("res://assets/icons/icon.png")
]
var id : int = -1

@export var item_name : String = "Name"

@export var description : String = "Placeholder description" # (String, MULTILINE)

@export var icon : Texture2D

@export var primary_slot_type: Slot

@export var consumed_on_acquire : bool = false

@export var constitution_bonus := 0
@export var strength_bonus := 0
@export var dexterity_bonus := 0

var currency_generated : int = 0 #TODO: Implement

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
		Slot.LEGS:
			return "L"
		Slot.FEET:
			return "F"
		Slot.ACCESSORY:
			return "A"
	return ""

static func shortname_to_slot(slot_name):
	match slot_name:
		"W":
			return Slot.HAND
		"O":
			return Slot.OFFHAND
		"H":
			return Slot.HEAD
		"C":
			return Slot.CHEST
		"L":
			return Slot.LEGS
		"F":
			return Slot.FEET
		"A":
			return Slot.ACCESSORY
	return Slot.NONE

static func make_item_preview(item) -> TextureRect:
	var sprite = TextureRect.new()
	if is_instance_valid(item):
		sprite.texture = item.icon
	return sprite

func _init(item_data : ItemData):
	id = item_data.id
	item_name = item_data.item_name
	description = item_data.description
	icon = item_data.icon
	primary_slot_type = item_data.primary_slot_type
	consumed_on_acquire = item_data.consumed_on_acquire
	constitution_bonus = item_data.constitution_bonus
	strength_bonus = item_data.strength_bonus
	dexterity_bonus = item_data.dexterity_bonus
	currency_generated = item_data.currency_generated

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
	return base_value + ceil((dexterity_bonus + strength_bonus + constitution_bonus) / 10.0)

func get_currency_granted():
	if consumed_on_acquire:
		var currencies = Currencies.new()
		currencies.gold = currency_generated
		return currencies
	return null

func get_container() -> ItemContainer:
	var parent = get_parent()
	if parent is ItemContainer:
		return parent
	return null
