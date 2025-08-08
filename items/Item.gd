extends Node
class_name Item

signal item_changed()

enum Slot {
	WEAPON,
	CHEST,
	HEAD,
	LEGS,
	FEET,
	POTION,
	RANGED,
	BELT,
	RING,
	CAPE,
	NONE
}

const slot_container_icons = [
	preload("res://assets/icons/slots/weapon.png"),
	preload("res://assets/icons/slots/chest.png"),
	preload("res://assets/icons/slots/head.png"),
	preload("res://assets/icons/slots/legs.png"),
	preload("res://assets/icons/slots/boot.png"),
	preload("res://assets/icons/resources/bottle.png"),
	preload("res://assets/icons/items/bow.png"),
	preload("res://assets/icons/items/belt.png"),
	preload("res://assets/icons/slots/ring.png"),
	preload("res://assets/icons/slots/cape.png"),
	preload("res://assets/icons/icon.png")
]

const slot_mini_icons = [
	preload("res://assets/icons/slots/weapon_slot.png"),
	preload("res://assets/icons/slots/chest_slot.png"),
	preload("res://assets/icons/slots/helm_slot.png"),
	preload("res://assets/icons/slots/leg_slot.png"),
	preload("res://assets/icons/slots/feet_slot.png"),
	preload("res://assets/icons/slots/potion_slot.png"),
	preload("res://assets/icons/slots/ranged_slot.png"),
	preload("res://assets/icons/slots/belt_slot.png"),
	preload("res://assets/icons/slots/ring_slot.png"),
	preload("res://assets/icons/slots/cape_slot.png"),
	preload("res://assets/icons/icon.png")
]

var id : int = -1

@export var item_name : String = "Name"

@export var description : String = "Placeholder description" # (String, MULTILINE)

@export var icon : Texture2D

@export var primary_slot_type: Slot

@export var consumed_on_acquire : bool = false

var stats : AbilityStats = AbilityStats.new()
var currency_generated : int = 0 #TODO: Implement
var base_value := 1
var loaned_character = null
var rarity : Globals.Rarity

static func slot_to_shortname(slot):
	match slot:
		Slot.WEAPON:
			return "W"
		Slot.CHEST:
			return "CH"
		Slot.HEAD:
			return "H"
		Slot.LEGS:
			return "L"
		Slot.FEET:
			return "F"
		Slot.POTION:
			return "P"
		Slot.RANGED:
			return "RA"
		Slot.BELT:
			return "B"
		Slot.RING:
			return "RI"
		Slot.CAPE:
			return "CA"
	return ""

static func shortname_to_slot(slot_name):
	match slot_name:
		"W":
			return Slot.WEAPON
		"CH":
			return Slot.CHEST
		"H":
			return Slot.HEAD
		"L":
			return Slot.LEGS
		"F":
			return Slot.FEET
		"P":
			return Slot.POTION
		"RA":
			return Slot.RANGED
		"B":
			return Slot.BELT
		"RI":
			return Slot.RING
		"CA":
			return Slot.CAPE
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
	currency_generated = item_data.currency_generated
	stats.values = item_data.stat_values
	base_value = item_data.value
	rarity = item_data.rarity
	name = item_name

func get_value() -> int:
	return base_value

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
