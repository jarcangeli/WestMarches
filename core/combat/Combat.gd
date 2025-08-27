extends RefCounted
class_name Combat

signal combat_log(line : String)
signal combat_story(line : String)

var adventurers : Array
var monsters : Array
var simulated := false

var round_number := 0
var remaining_adventurers_alive := 0
var remaining_monsters_alive := 0
var cached_round_order = null
var poison_damage_map = {}
var poison_source_map = {}
var killed_characters = []
var combat_summary = {}

func _init(_adventurers : Array[Character], _monsters : Array[Character]):
	set_characters(_adventurers, _monsters)

func play_through():
	while (!is_finished()):
		play_round()

func set_characters(_adventurers : Array[Character], _monsters : Array[Character]):
	adventurers = _adventurers
	monsters = _monsters
	adventurers.sort_custom(sort_character_order)
	monsters.sort_custom(sort_character_order)
	reset()

func reset():
	round_number = 0
	cached_round_order = null
	poison_damage_map = {}
	poison_source_map = {}
	killed_characters = []
	combat_summary = {}
	reset_characters(adventurers)
	reset_characters(monsters)
	remaining_adventurers_alive = 0
	for adventurer in adventurers:
		if adventurer.is_alive():
			remaining_adventurers_alive += 1
			var summary = CharacterCombatSummary.new()
			summary.adventurer = true
			combat_summary[adventurer] = summary
	remaining_monsters_alive = 0
	for monster in monsters:
		if monster.is_alive():
			remaining_monsters_alive += 1
			var summary = CharacterCombatSummary.new()
			summary.adventurer = false
			combat_summary[monster] = summary

func set_simulated(enabled : bool):
	simulated = enabled

func add_log(message : String):
	if simulated:
		return
	combat_log.emit(message)

func add_story(message : String):
	if simulated:
		return
	combat_log.emit(message)
	combat_story.emit(message)

func sort_round_order(a, b):
	var initiative_a = a[0].stats.get_value(AbilityStats.Type.INTIATIVE)
	var initiative_b = b[0].stats.get_value(AbilityStats.Type.INTIATIVE)
	if initiative_a > initiative_b:
		return true
	return false

func sort_character_order(a, b):
	var hp_a = a.stats.get_value(AbilityStats.Type.CONSTITUTION)
	var hp_b = b.stats.get_value(AbilityStats.Type.CONSTITUTION)
	if hp_a > hp_b:
		return true
	return false

func get_round_order(): #returns character and targets pair
	if cached_round_order:
		return cached_round_order
	var character_order = []
	for character in adventurers:
		if character.is_alive():
			character_order.append([character, monsters])
	for character in monsters:
		if character.is_alive():
			character_order.append([character, adventurers])
	character_order.shuffle() # break ties
	character_order.sort_custom(sort_round_order)
	cached_round_order = character_order
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
		if not is_finished():
			play_turn(character_target[0], character_target[1])
	
	if is_finished():
		if not simulated:
			var n = adventurers_alive()
			if n > 0:
				# award any exp to the survivors
				var experience : int = ceil(TK.experience_from_monsters(monsters) / float(n))
				for adventurer in adventurers:
					if adventurer.is_alive():
						adventurer.modify_exp(experience)
		add_log("End of combat!")

func play_turn(character : Character, enemies : Array):
	if not character.is_alive() or is_finished():
		return
	
	# Attack
	var enemy : Character = target_character(enemies)
	if not enemy:
		return # all died, thorns?
	const HIT_DICE = 20
	var roll := randi() % HIT_DICE + 1
	add_log("%s rolled %d" % [character.name, roll])
	var hit = roll + character.stats.get_value(AbilityStats.Type.ATTACK) \
							- enemy.stats.get_value(AbilityStats.Type.AVOIDANCE)
	var damage = (randi() % 6 + 1) * character.stats.get_value(AbilityStats.Type.DAMAGE_DIE) \
					+ character.stats.get_value(AbilityStats.Type.DAMAGE_BONUS)
	
	var crit : bool = roll > (HIT_DICE - character.stats.get_value(AbilityStats.Type.CRIT_RATE))
	if roll == 1:
		hit = false
		damage = 0
		add_log(character.name + " critical miss on " + enemy.name)
	elif crit:
		hit = true
		damage = 2 * damage
		do_damage(character, enemy, damage, CharacterCombatSummary.Stat.CRIT_DAMAGE)
		add_log("%s critical hit on %s for %d damage! (%d/%d)" % [character.name, enemy.name, damage, enemy.health, enemy.get_max_health()])
	elif not hit:
		add_log(character.name + " missed " + enemy.name)
	else:
		do_damage(character, enemy, damage, CharacterCombatSummary.Stat.ATTACK_DAMAGE)
		add_log("%s dealt %d damage to %s (%d/%d)" % [character.name, damage, enemy.name, enemy.health, enemy.get_max_health()])
	
	if !enemy.is_alive():
		on_kill_character(enemy)
	
	# AOE Damage
	var aoe_damage = character.stats.get_value(AbilityStats.Type.AOE_DAMAGE)
	if damage > 0 and aoe_damage > 0:
		for aoe_enemy in enemies:
			if enemy != aoe_enemy and aoe_enemy.is_alive():
				do_damage(character, aoe_enemy, aoe_damage, CharacterCombatSummary.Stat.AOE_DAMAGE)
				add_log("%s suffered %d AOE damage damage from %s (%d/%d)" % [aoe_enemy.name, aoe_damage, character.name, aoe_enemy.health, aoe_enemy.get_max_health()])
				if !aoe_enemy.is_alive():
					on_kill_character(aoe_enemy)
	
	# Snipe damage
	var snipe_damage = character.stats.get_value(AbilityStats.Type.SNIPE_DAMAGE)
	if damage > 0 and snipe_damage > 0:
		var snipe_enemy = target_weakest_character(enemies) 
		if snipe_enemy:
			do_damage(character, snipe_enemy, snipe_damage, CharacterCombatSummary.Stat.SNIPE_DAMAGE)
			add_log("%s suffered %d snipe damage from %s (%d/%d)" % [snipe_enemy.name, snipe_damage, character.name, snipe_enemy.health, snipe_enemy.get_max_health()])
			if !snipe_enemy.is_alive():
				on_kill_character(snipe_enemy)
	
	# Poison chance
	var poison_chance = character.stats.get_value(AbilityStats.Type.POISON_CHANCE)
	if poison_chance > 0 and damage > 0 and (randi() % 100) < poison_chance:
		var poison_damage = character.stats.get_value(AbilityStats.Type.POISON_DAMAGE)
		var current_damage = poison_damage_map.get(enemy, 0)
		if poison_damage > current_damage:
			poison_damage_map.set(enemy, poison_damage)
			poison_source_map.set(enemy, character)
			add_log("%s was poisoned" % enemy.name)
	
	# Poison damage
	var poisoned_damage = poison_damage_map.get(character, 0)
	if poisoned_damage > 0 and character.is_alive():
		var source = poison_source_map.get(character)
		do_damage(source, character, poisoned_damage, CharacterCombatSummary.Stat.POISON_DAMAGE)
		add_log("%s suffered %d poison damage (%d/%d)" % [character.name, poisoned_damage, character.health, character.get_max_health()])
	
	# Thorns
	var thorns = enemy.stats.get_value(AbilityStats.Type.THORNS)
	if damage > 0 and thorns > 0 and character.is_alive():
		do_damage(enemy, character, poisoned_damage, CharacterCombatSummary.Stat.THORNS_DAMAGE)
		add_log("%s suffered %d thorns damage from %s (%d/%d)" % [character.name, thorns, enemy.name, character.health, character.get_max_health()])

	# Healing
	if character.is_alive():
		var healing = character.stats.get_value(AbilityStats.Type.REGENERATION)
		var healed = do_healing(character, healing)
		if healed:
			add_log("%s healed for %d hitpoints (%d/%d)" % [character.name, healed, character.health, character.get_max_health()])
	
	if !character.is_alive():
		on_kill_character(character)

func target_character(characters):
	for character in characters:
		if character.is_alive():
			return character
	return null

func target_weakest_character(characters):
	var lowest_hp = 0
	var target = null
	for character in characters:
		if character.is_alive() and (character.health < lowest_hp or lowest_hp == 0):
			target = character
	return target

func on_kill_character(character : Character):
	add_story(character.name + " was slain")
	killed_characters.append(character)
	combat_summary[character].dead = true
	if character in monsters:
		remaining_monsters_alive -= 1
	elif character in adventurers:
		remaining_adventurers_alive -= 1

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

func do_damage(source : Character, target : Character, value : int, type: CharacterCombatSummary.Stat):
	target.damage(value)
	
	if simulated:
		return
	# Track
	if source:
		var source_summary = combat_summary.get(source, CharacterCombatSummary.new())
		source_summary.character_name = source.name
		source_summary.damage_done[type] += value
		combat_summary.set(source, source_summary)
	var target_summary = combat_summary.get(target, CharacterCombatSummary.new())
	target_summary.character_name = target.name
	target_summary.damage_received[type] += value
	combat_summary.set(target, target_summary)

func do_healing(character : Character, value : int):
	var healed = character.heal(value)
	if simulated:
		return healed
		
	# Track
	var summary = combat_summary.get(character, CharacterCombatSummary.new())
	summary.character_name = character.name
	summary.healing += healed
	combat_summary.set(character, summary)
	return healed

static func reset_characters(characters : Array[Character]):
	for character in characters:
		character.health = character.get_max_health()
