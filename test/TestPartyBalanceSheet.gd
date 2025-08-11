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
	
	var results = {}
	for poi : POIData in POIDatabase.pois_by_name.values():
		var poi_results = {}
		for encounter : EncounterData in poi.encounters:
			# Load monsters
			var monsters : Array[Character] = []
			for monster_name in encounter.monster_names:
				var monster_data : CharacterData = MonsterDatabase.get_data_by_name(monster_name)
				if not monster_data.valid():
					push_error("Invalid monster % in encounter %s - %s " % [monster_name, poi.poi_name, encounter.encounter_name] )
					continue
				var monster = Character.new(monster_data)
				monsters.append(monster)
			
			# Sim combat
			var result := CombatSim.simulate(party.get_characters(), monsters, iterations)
			total_iterations += iterations
			poi_results[encounter.encounter_name] = result
		results[poi.poi_name] = poi_results
	
	display(party, results)
	
	var end = Time.get_ticks_msec()
	print("Simulation completed in %d msecs" % (end - start))
	print("\tor %.2f msecs per iteration" % ((end - start)/float(total_iterations)))
	print("\tor %d usecs per iteration" % int((end - start)/float(total_iterations)*1000.))

func display(party, results : Dictionary):
	for node in results_container.get_children():
		node.queue_free()
	
	party_summary_ui.set_party(party)
	
	var texts = []
	for poi_name in results.keys():
		texts.append(poi_name)
		var poi : POIData = POIDatabase.pois_by_name[poi_name]
		display_label_text(poi_name)
		for _i in range(0, 5):
			display_label_text('')
		
		for encounter_data in poi.encounters:
			display_label_text(encounter_data.encounter_name)
			
			var monsters = ', '.join(encounter_data.monster_names)
			
			var monsters_power_level = 0
			var largest_attack := 0
			var largest_defence := 0
			for monster_name in encounter_data.monster_names:
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
			var result : CombatSimResults = results[poi_name][encounter_data.encounter_name]
			display_label_text(str(int(result.get_win_percentage())) + '%')
			display_label_text(result.get_average_character_deaths())
			display_label_text(monsters)

func display_label_text(text):
	var label = Label.new()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.text = str(text)
	results_container.add_child(label)
