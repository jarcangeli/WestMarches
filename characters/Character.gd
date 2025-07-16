extends ItemContainer
class_name Character

@export var character_name : String

@export var level : int = 1

var equip_slots : Dictionary

var debt : int = 0

@export var base_constitution := 10
@export var base_strength := 10
@export var base_dexterity := 10

@onready var health := get_max_health()

func _ready():
	equip_best_gear() #TODO: Remove from _ready

func is_alive():
	return health > 0

func get_strength() -> int:
	var strength = base_strength
	for item : Item in get_equipped_items():
		strength += item.strength_bonus
	return clamp(strength, 0, strength)

func get_dexterity() -> int:
	var dexterity = base_dexterity
	for item : Item in get_equipped_items():
		dexterity += item.dexterity_bonus
	return clamp(dexterity, 0, dexterity)

func get_constitution() -> int:
	var constitution = base_constitution
	for item : Item in get_equipped_items():
		constitution += item.consitution_bonus
	return clamp(constitution, 1, constitution)

func get_max_health() -> int:
	return get_constitution() * 10

func damage(value : int):
	health -= clamp(value, 0, value)

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

func get_equipped_items():
	var items = []
	for item in equip_slots.values():
		if item == null or item.get_parent() != self:
			continue
		items.append(item)
	return items
