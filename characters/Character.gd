extends ItemContainer
class_name Character

signal died()

@export var character_name : String

var id := -1
var equip_slots : Dictionary
var debt : int = 0

var base_stats := AbilityStats.new()
var stats := CharacterStats.new(base_stats, self)

@onready var health := get_max_health()

var experience := 0

func _ready():
	child_entered_tree.connect(equip_best_gear, CONNECT_DEFERRED)
	child_exiting_tree.connect(equip_best_gear, CONNECT_DEFERRED)
	equip_best_gear() #TODO: Remove from _ready

func _init(data : CharacterData = null):
	if not data:
		return #TODO: This is just for prototyping characters in place, remove
	id = data.id
	character_name = data.character_name
	base_stats.values = data.stats.values
	stats.invalidate_cache()
	set_name(character_name)

func is_alive():
	return health > 0

func get_max_health() -> int:
	return stats.get_value(AbilityStats.Type.CONSTITUTION) * 10

func get_level() -> int:
	return TuningKnobs.level_from_experience(experience)

func get_power_level() -> int:
	return stats.get_weighted_sum()

func damage(value : int):
	health -= clamp(value, 0, value)

func get_loaned_items():
	var items = []
	for node in get_children():
		if node is Item and node.loaned_character == self:
			items.append(node)
	return items

func equip_best_gear(_dummy = null):
	var items = get_items()
	for item : Item in items:
		if not equip_slots.has(item.primary_slot_type):
			equip_slots[item.primary_slot_type] = item
		else:
			if equip_slots.get(item.primary_slot_type).get_value() < item.get_value():
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

func modify_exp(gain):
	experience += gain

func on_death():
	#TODO: Move all items into the party inventory so they aren't lost
	if get_parent():
		get_parent().remove_child(self)
	Globals.character_graveyard.add_child(self)
	died.emit()
