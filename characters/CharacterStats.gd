extends AbilityStats
class_name CharacterStats

var cache_valid : Array[bool]
var base_stats : AbilityStats
var character : ItemContainer

func _init(_base_stats : AbilityStats, _character : Character):
	base_stats = _base_stats
	character = _character
	invalidate_cache()

func get_value(type : AbilityStats.Type) -> int:
	if not cache_valid[type]:
		calculate_value(type) #update cache
	return values[type]

func get_values() -> Array[int]:
	var return_values : Array[int] = []
	for i in range(0, AbilityStats.Type.SIZE):
		return_values.append(get_value(i))
	return return_values

func set_value(type : AbilityStats.Type, value : int) -> void:
	values[type] = value

func calculate_value(type : AbilityStats.Type):
	var value = base_stats.get_value(type)
	for item : Item in character.get_equipped_items():
		value += item.stats.get_value(type)
	values[type] = value
	cache_valid[type] = true

func invalidate_cache():
	cache_valid = []
	for i in range(len(values)):
		cache_valid.append(false)

func get_weighted_value():
	var sum := 0
	for i in range(len(values)):
		sum += get_value(i) *  weights[i]
	return sum
