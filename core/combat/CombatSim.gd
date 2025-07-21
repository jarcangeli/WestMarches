extends RefCounted
class_name CombatSim

static func simulate(adventurers : Array[Character], monsters : Array[Character], iterations := 100) -> ComatSimResults:
	#TODO: In need of giga-optimization
	# can try to cache all the character stats and equipment stats when items are equipped
	var results = ComatSimResults.new()
	var combat = Combat.new(adventurers, monsters)
	combat.set_simulated(true)
	for i in range(0, iterations):
		reset_characters(adventurers)
		reset_characters(monsters)
		combat.reset()
		while !combat.is_finished():
			combat.play_round()
		var monsters_alive : bool = combat.monsters_alive()
		var adventurers_alive : bool = combat.adventurers_alive()
		
		if monsters_alive or not adventurers_alive:
			results.losses += 1
		else:
			results.wins += 1
	
	reset_characters(adventurers)
	reset_characters(monsters)
	return results

static func reset_characters(characters : Array[Character]):
	for character in characters:
		character.health = character.get_max_health()
