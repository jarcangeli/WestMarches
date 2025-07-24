extends RefCounted
class_name CharacterCombatSummary

enum Stat
{
	ATTACK_DAMAGE,
	CRIT_DAMAGE,
	THORNS_DAMAGE,
	POISON_DAMAGE,
	AOE_DAMAGE,
	SNIPE_DAMAGE,
	SIZE
}

var damage_done : Array[int]
var damage_received : Array[int]
var healing := 0

func _init():
	damage_done = []
	damage_done.resize(Stat.SIZE)
	damage_done.fill(0)
	damage_received = []
	damage_received.resize(Stat.SIZE)
	damage_received.fill(0)
