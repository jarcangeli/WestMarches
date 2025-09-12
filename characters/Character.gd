extends ItemContainer
class_name Character

signal died()

enum CharacterClass
{
	NONE,
	BRAWLER,
	RANGER,
	THIEF,
	CHAMPION,
	SIZE
}

@export var character_name : String
@export var experience := 0
@export var character_class : CharacterClass = CharacterClass.BRAWLER

@onready var health := get_max_health()

var id := -1
var equip_slots : Dictionary
var base_stats := AbilityStats.new()
var stats := CharacterStats.new(base_stats, self)
var dead := false

func _ready():
	equip_best_gear() #TODO: Remove from _ready

func _init(data : CharacterData = null):
	if not data:
		return #TODO: This is just for prototyping characters in place, remove
	id = data.id
	character_name = data.character_name
	base_stats.values = data.stats.values
	stats.invalidate_cache()
	set_name(character_name)

static func character_class_to_string(_character_class : CharacterClass):
	match _character_class:
		CharacterClass.BRAWLER:
			return "Fighter"
		CharacterClass.RANGER:
			return "Ranger"
		CharacterClass.THIEF:
			return "Thief"
		CharacterClass.CHAMPION:
			return "Champion"
	return "None"

func is_alive(): # TODO: Rework to use dead? (care in combat)
	return health > 0 and not dead

func get_max_health() -> int:
	return stats.get_value(AbilityStats.Type.CONSTITUTION)

func get_level() -> int:
	return TK.level_from_experience(experience)

func get_unlocked_slots() -> Array:
	var slot_unlock_order : Array = TK.SLOT_UNLOCK_ORDER_BY_CLASS.get(character_class)
	if not slot_unlock_order:
		slot_unlock_order = TK.SLOT_UNLOCK_ORDER_BY_CLASS.get(Character.CharacterClass.BRAWLER)
	var level = get_level()
	
	var unlocked_slots = []
	for slot in TK.GLOBAL_UNLOCKED_SLOTS:
		unlocked_slots.append(slot)
	for i in range(0, level):
		if len(slot_unlock_order) > i:
			unlocked_slots.append(slot_unlock_order[i])
	return unlocked_slots

func get_power_level() -> int:
	return stats.get_weighted_value()

func damage(value : int):
	health -= clamp(value, 0, value)

func heal(value : int):
	var old_health = health
	health = clampi(health + value, health, get_max_health())
	return health - old_health

func get_loaned_items():
	var items = []
	for node in get_children():
		if node is Item and node.loaned_character:
			items.append(node)
	return items

func unequip_item(item : Item):
	for slot in equip_slots.keys():
		var slot_item = equip_slots[slot]
		if slot_item == item:
			slot_item = null
			equip_slots.erase(slot)
			return

func unequip_all_items():
	equip_slots.clear()

func equip_best_gear(item_pool = null):
	var items = get_items()
	var unlocked_slots = get_unlocked_slots()
	
	for item : Item in items:
		if not item.primary_slot_type in unlocked_slots:
			continue
		
		if not equip_slots.has(item.primary_slot_type) or equip_slots.get(item.primary_slot_type) == null:
			equip_slots[item.primary_slot_type] = item
		else:
			if equip_slots.get(item.primary_slot_type).get_value() < item.get_value():
				equip_slots[item.primary_slot_type] = item
	if is_instance_valid(item_pool) and item_pool is ItemContainer:
		for item : Item in item_pool.get_items():
			if not equip_slots.has(item.primary_slot_type) or equip_slots.get(item.primary_slot_type) == null:
				add_item(item)
				equip_slots[item.primary_slot_type] = item
			else:
				if equip_slots.get(item.primary_slot_type).get_value() < item.get_value():
					add_item(item)
					equip_slots[item.primary_slot_type] = item
	stats.invalidate_cache()

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

func get_unequipped_items():
	var equipped_items = get_equipped_items()
	var items = []
	for item in get_items():
		if item == null or item in equipped_items:
			continue
		items.append(item)
	return items

func modify_exp(gain):
	experience += gain

func on_death():
	var party = get_parent() as AdventuringParty
	if party:
		unequip_all_items()
		var items = get_unequipped_items()
		party.add_items(items)
	SignalBus.character_died.emit(self)
	dead = true
	died.emit()
