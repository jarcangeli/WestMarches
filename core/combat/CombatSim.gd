extends RefCounted
class_name CombatSim

static func simulate(adventurers : Array[Character], monsters : Array[Character], iterations := 100) -> CombatSimResults:
	#TODO: In need of giga-optimization
	# can try to cache all the character stats and equipment stats when items are equipped
	var results = CombatSimResults.new()
	var combat = Combat.new(adventurers, monsters)
	combat.set_simulated(true)
	for i in range(0, iterations):
		combat.reset()
		while !combat.is_finished():
			combat.play_round()
		var monsters_alive : int = combat.monsters_alive()
		var adventurers_alive : int = combat.adventurers_alive()
		
		results.character_deaths += len(adventurers) - adventurers_alive
		if monsters_alive or not adventurers_alive:
			results.losses += 1
		else:
			results.wins += 1
	
	combat.reset()
	return results
