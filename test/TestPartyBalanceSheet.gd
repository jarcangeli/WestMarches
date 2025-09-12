extends HBoxContainer
class_name TestPartyBalanceSheet

@export var results_container : Container

@onready var party_summary_ui: PartySummaryUI = %PartySummaryUI

func test_encounters(party, iterations):
	for character in party.get_characters():
		character.equip_best_gear()
	
	# Now run a sim
	var start = Time.get_ticks_msec()
	var total_iterations := 0
	
	var results = []
	for encounter : Encounter in POIDatabase.all_encounters:
		# Load monsters
		encounter.generate_monsters()
		var monsters = encounter.get_monsters()
		
		# Sim combat
		var result := CombatSim.simulate(party.get_characters(), monsters, iterations)
		total_iterations += iterations
		result.encounter = encounter
		results.append(result)
	
	results.sort_custom(sort_results)
	display(party, results)
	
	var end = Time.get_ticks_msec()
	print("Simulation completed in %d msecs" % (end - start))
	print("\tor %.2f msecs per iteration" % ((end - start)/float(total_iterations)))
	print("\tor %d usecs per iteration" % int((end - start)/float(total_iterations)*1000.))

func display(party, results):
	for node in results_container.get_children():
		node.queue_free()
	
	party_summary_ui.set_party(party)
	
	display_label_text("name")
	display_label_text("power")
	display_label_text("atk/def")
	display_label_text("win%")
	display_label_text("deaths")
	display_label_text("monsters")
	
	for result in results:
		var encounter = result.encounter
		display_label_text(encounter.encounter_name)
		
		var monsters = ', '.join(encounter.monster_names)
		
		var monsters_power_level = 0
		var largest_attack := 0
		var largest_defence := 0
		for monster_name in encounter.monster_names:
			var monster_data : CharacterData = MonsterDatabase.get_data_by_name(monster_name)
			var monster = Character.new(monster_data)
			monsters_power_level += monster.get_power_level()
			
			var attack = monster.stats.get_value(AbilityStats.Type.ATTACK)
			var defence = monster.stats.get_value(AbilityStats.Type.AVOIDANCE)
			if attack > largest_attack:
				largest_attack = attack
			if defence > largest_defence:
				largest_defence = defence
		
		display_label_text(monsters_power_level)
		display_label_text("%d/%d " % [largest_attack, largest_defence])
		display_label_text(str(int(result.get_win_percentage())) + '%')
		display_label_text(result.get_average_character_deaths())
		display_label_text(monsters)

func display_label_text(text):
	var label = Label.new()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.text = str(text)
	results_container.add_child(label)

func sort_results(a, b):
	return a.character_deaths < b.character_deaths
