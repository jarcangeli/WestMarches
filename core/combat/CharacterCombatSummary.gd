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

var character_name : String
var adventurer := false
var damage_done : Array[int]
var damage_received : Array[int]
var healing := 0
var dead := false

func _init():
	damage_done = []
	damage_done.resize(Stat.SIZE)
	damage_done.fill(0)
	damage_received = []
	damage_received.resize(Stat.SIZE)
	damage_received.fill(0)

func total_damage_done():
	var tot = 0
	for val in damage_done:
		tot += val
	return tot

func total_damage_received():
	var tot = 0
	for val in damage_received:
		tot += val
	return tot
