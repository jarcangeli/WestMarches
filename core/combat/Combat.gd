extends Node
class_name Combat

signal combat_log(line : String)

var adventurers : Array
var monsters : Array

var round := 0

func _init(_adventurers : Array, _monsters : Array):
	adventurers = _adventurers
	monsters = _monsters

func play_round():
	if is_finished():
		return
	round += 1
	if round == 1:
		combat_log.emit("Start of combat!")
	combat_log.emit("Start of round %d" % round)
	
	for adventurer in adventurers:
		play_turn(adventurer, monsters)
	for monster in monsters:
		play_turn(monster, adventurers)
	
	if is_finished():
		combat_log.emit("End of combat!")

func play_turn(character : Character, enemies : Array):
	if not character.is_alive() or is_finished():
		return
	
	var roll := randi() % 100
	combat_log.emit("%s rolled %d" % [character.character_name, roll])
	var enemy : Character = enemies[randi() % len(enemies)]
	var damage = roll + character.get_strength() - enemy.get_dexterity()
	if damage > 0:
		enemy.damage(damage)
		combat_log.emit("%s dealt %d damage to %s (%d/%d)" % [character.character_name, damage, enemy.character_name, enemy.health, enemy.get_max_health()])
		if not enemy.is_alive():
			combat_log.emit(enemy.character_name + " was slain")
	else:
		combat_log.emit(character.character_name + " missed " + enemy.character_name)

func is_finished():
	return not adventurers_alive() or not monsters_alive()

func adventurers_alive() -> bool:
	for adventurer in adventurers:
		if adventurer.is_alive():
			return true
	return false

func monsters_alive() -> bool:
	for monster in monsters:
		if monster.is_alive():
			return true
	return false
