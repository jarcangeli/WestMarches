extends RefCounted
class_name AbilityStats

enum Type
{
	CONSTITUTION,
	ATTACK,
	AVOIDANCE,
	INTIATIVE,
	CRIT_RATE,
	REGENERATION,
	THORNS,
	AOE_ATTACK,
	POISON_CHANCE,
	POISON_DAMAGE,
	SNIPE_ATTACK
}

var values : Array[int] = [
	10, # CONSTITUTION
	10, # ATTACK
	10, # AVOIDANCE
	10, # INTIATIVE
	1, 	# CRIT_RATE
	0,	# REGENERATION
	0,	# THORNS
	0,	# AOE_ATTACK
	0,	# POISON_CHANCE
	1,	# POISON_DAMAGE
	0	# SNIPE_ATTACK
]

func get_value(type : AbilityStats.Type) -> int:
	return values[type]

func set_value(type : AbilityStats.Type, value : int) -> void:
	values[type] = value

func get_weighted_sum(): #TODO: Weight
	var sum := 0
	for value in values:
		sum += value
	return sum
