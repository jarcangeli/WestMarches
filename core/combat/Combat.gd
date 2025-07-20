extends RefCounted
class_name Combat

signal combat_log(line : String)

var adventurers : Array
var monsters : Array

var round_number := 0

var exp_enabled := true

func _init(_adventurers : Array[Character], _monsters : Array[Character]):
	adventurers = _adventurers
	monsters = _monsters

func set_exp_enabled(enabled : bool):
	exp_enabled = enabled

func play_round():
	if is_finished():
		return
	round_number += 1
	if round_number == 1:
		combat_log.emit("Start of combat!")
	combat_log.emit("Start of round %d" % round_number)
	
	for adventurer in adventurers:
		play_turn(adventurer, monsters)
	for monster in monsters:
		play_turn(monster, adventurers)
	
	if is_finished():
		var n = adventurers_alive()
		if n > 0:
			# award any exp to the survivors
			var experience : int = ceil(get_exp_for_monsters() / float(n))
			for adventurer in adventurers:
				if adventurer.is_alive():
					adventurer.modify_exp(experience)
		combat_log.emit("End of combat!")

func play_turn(character : Character, enemies : Array):
	if not character.is_alive() or is_finished():
		return
	
	var roll := randi() % 100 + 1
	combat_log.emit("%s rolled %d" % [character.character_name, roll])
	var enemy : Character = enemies[randi() % len(enemies)] # TODO: Choose highest HP?
	var damage = roll + character.get_strength() - enemy.get_dexterity()
	if roll == 100: #TODO: Add crit bonus stat
		damage = roll + character.get_strength()
	
	if roll == 1:
		combat_log.emit(character.character_name + " critical miss on " + enemy.character_name)
	elif damage > 0:
		enemy.damage(damage)
		if roll == 100:
			combat_log.emit("%s critical hit on %s for %d damage! (%d/%d)" % [character.character_name, enemy.character_name, damage, enemy.health, enemy.get_max_health()])
		else:
			combat_log.emit("%s dealt %d damage to %s (%d/%d)" % [character.character_name, damage, enemy.character_name, enemy.health, enemy.get_max_health()])
		
		if not enemy.is_alive():
			combat_log.emit(enemy.character_name + " was slain")
	else:
		combat_log.emit(character.character_name + " missed " + enemy.character_name)

func is_finished():
	return not adventurers_alive() or not monsters_alive()

func adventurers_alive():
	var count := 0
	for adventurer in adventurers:
		if adventurer.is_alive():
			count += 1
	return count

func monsters_alive() -> bool:
	for monster in monsters:
		if monster.is_alive():
			return true
	return false

func get_exp_for_monsters() -> int:
	var experience = 0
	for monster in monsters:
		if not monster.is_alive():
			experience += min(monster.get_power_level(), 30)
	return experience
