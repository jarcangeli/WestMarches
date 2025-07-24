extends RefCounted
class_name Combat

signal combat_log(line : String)

var adventurers : Array
var monsters : Array

var remaining_adventurers_alive := 0
var remaining_monsters_alive := 0

var round_number := 0

var simulated := false

func _init(_adventurers : Array[Character], _monsters : Array[Character]):
	set_characters(_adventurers, _monsters)

func set_characters(_adventurers : Array[Character], _monsters : Array[Character]):
	adventurers = _adventurers
	monsters = _monsters
	reset()

func reset():
	round_number = 0
	remaining_adventurers_alive = 0
	for adventurer in adventurers:
		if adventurer.is_alive():
			remaining_adventurers_alive += 1
	remaining_monsters_alive = 0
	for monster in monsters:
		if monster.is_alive():
			remaining_monsters_alive += 1

func set_simulated(enabled : bool):
	simulated = enabled

func add_log(message : String):
	if simulated:
		return
	combat_log.emit(message)

func sort_round_order(a, b):
	var initiative_a = a[0].stats.get_value(AbilityStats.Type.INTIATIVE)
	var initiative_b = b[0].stats.get_value(AbilityStats.Type.INTIATIVE)
	if initiative_a > initiative_b:
		return true
	return false

func get_round_order(): #returns character and targets pair
	var character_order = []
	for character in adventurers:
		if character.is_alive():
			character_order.append([character, monsters])
	for character in monsters:
		if character.is_alive():
			character_order.append([character, adventurers])
	character_order.shuffle() # break ties
	character_order.sort_custom(sort_round_order)
	return character_order

func play_round():
	if is_finished():
		return
	round_number += 1
	if round_number == 1:
		add_log("Start of combat!")
	add_log("Start of round %d" % round_number)
	
	var character_target_order = get_round_order()
	for character_target in character_target_order:
			play_turn(character_target[0], character_target[1])
	
	if is_finished():
		if not simulated:
			var n = adventurers_alive()
			if n > 0:
				# award any exp to the survivors
				var experience : int = ceil(TuningKnobs.experience_from_monsters(monsters) / float(n))
				for adventurer in adventurers:
					if adventurer.is_alive():
						adventurer.modify_exp(experience)
		add_log("End of combat!")

func play_turn(character : Character, enemies : Array):
	if not character.is_alive() or is_finished():
		return
	
	var roll := randi() % 100 + 1
	add_log("%s rolled %d" % [character.name, roll])
	var enemy : Character = target_character(enemies)
	if not enemy:
		push_warning("Trying to attack but no characters")
		return
	var damage = roll + character.stats.get_value(AbilityStats.Type.ATTACK) \
							- enemy.stats.get_value(AbilityStats.Type.AVOIDANCE)
	var crit : bool = roll > (100 - character.stats.get_value(AbilityStats.Type.CRIT_RATE))
	if crit:
		damage = roll + character.stats.get_value(AbilityStats.Type.ATTACK)
	
	if roll == 1:
		add_log(character.name + " critical miss on " + enemy.name)
	elif damage > 0:
		enemy.damage(damage)
		if crit:
			add_log("%s critical hit on %s for %d damage! (%d/%d)" % [character.name, enemy.name, damage, enemy.health, enemy.get_max_health()])
		else:
			add_log("%s dealt %d damage to %s (%d/%d)" % [character.name, damage, enemy.name, enemy.health, enemy.get_max_health()])
		
		if not enemy.is_alive():
			add_log(enemy.name + " was slain")
			if enemy in monsters:
				remaining_monsters_alive -= 1
			elif enemy in adventurers:
				remaining_adventurers_alive -= 1
	else:
		add_log(character.name + " missed " + enemy.name)

func target_character(characters):
	var highest_hp = 0
	var target = null
	for character in characters:
		if character.health > highest_hp:
			target = character
	return target

func is_finished():
	return remaining_adventurers_alive < 1 or remaining_monsters_alive < 1

func adventurers_alive():
	return remaining_adventurers_alive

func monsters_alive():
	return remaining_monsters_alive

func get_exp_for_monsters() -> int:
	var experience = 0
	for monster in monsters:
		if not monster.is_alive():
			experience += min(monster.get_power_level(), 30)
	return experience
