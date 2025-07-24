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
	SNIPE_DAMAGE,
	SIZE
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
	0	# SNIPE_DAMAGE
]

func get_value(type : AbilityStats.Type) -> int:
	return values[type]

func set_value(type : AbilityStats.Type, value : int) -> void:
	values[type] = value

#TODO: Remove dupe?
static var weights : Array[int] = [
	1, # CONSTITUTION
	1, # ATTACK
	1, # AVOIDANCE
	1, # INTIATIVE
	10, 	# CRIT_RATE
	1,	# REGENERATION
	1,	# THORNS
	3,	# AOE_ATTACK
	1,	# POISON_CHANCE
	1,	# POISON_DAMAGE
	2	# SNIPE_DAMAGE
]
func get_weighted_value():
	var sum := 0
	for i in range(len(values)):
		sum += values[i] *  weights[i]
	return sum
