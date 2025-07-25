extends RefCounted
class_name AbilityStats

const icon_root = "res://assets/icons/stats/"

enum Type
{
	CONSTITUTION,
	ATTACK,
	AVOIDANCE,
	INTIATIVE,
	CRIT_RATE,
	REGENERATION,
	THORNS,
	AOE_DAMAGE,
	POISON_CHANCE,
	POISON_DAMAGE,
	SNIPE_DAMAGE,
	SIZE
}

static var icons : Array[Texture2D] = [
	preload(icon_root + "constitution.png"), 	# CONSTITUTION
	preload(icon_root + "attack.png"), 			# ATTACK
	preload(icon_root + "avoidance.png"), 		# AVOIDANCE
	preload(icon_root + "initiative.png"), 		# INTIATIVE
	preload(icon_root + "crit_rate.png"), 		# CRIT_RATE
	preload(icon_root + "regeneration.png"),	# REGENERATION
	preload(icon_root + "thorns.png"),			# THORNS
	preload(icon_root + "aoe.png"),				# AOE_DAMAGE
	preload(icon_root + "poison_chance.png"),	# POISON_CHANCE
	preload(icon_root + "poison_damage.png"),	# POISON_DAMAGE
	preload(icon_root + "snipe.png")			# SNIPE_DAMAGE
]

static func get_icon(type : Type):
	if type == Type.SIZE:
		return null
	return icons[type]

var values : Array[int] = [
	10, # CONSTITUTION
	10, # ATTACK
	10, # AVOIDANCE
	10, # INTIATIVE
	1, 	# CRIT_RATE
	0,	# REGENERATION
	0,	# THORNS
	0,	# AOE_DAMAGE
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
	3,	# AOE_DAMAGE
	1,	# POISON_CHANCE
	1,	# POISON_DAMAGE
	2	# SNIPE_DAMAGE
]
func get_weighted_value():
	var sum := 0
	for i in range(len(values)):
		sum += values[i] *  weights[i]
	return sum
