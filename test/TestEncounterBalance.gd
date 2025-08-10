extends Control

@export var party : AdventuringParty
@export var results_text : TextEdit

@onready var party_summary_ui: PartySummaryUI = %PartySummaryUI

const iterations = 100

func test_encounters():
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
	
	display(results)
	
	var end = Time.get_ticks_msec()
	print("Simulation completed in %d msecs" % (end - start))
	print("\tor %.2f msecs per iteration" % ((end - start)/float(total_iterations)))
	print("\tor %d usecs per iteration" % int((end - start)/float(total_iterations)*1000.))

func display(results : Dictionary):
	party_summary_ui.set_party(party)
	
	var texts = []
	for poi_name in results.keys():
		texts.append(poi_name)
		var poi : POIData = POIDatabase.pois_by_name[poi_name]
		for encounter_data in poi.encounters:
			var monsters = ', '.join(encounter_data.monster_names)
			texts.append("\t%s - [%s]"% [encounter_data.encounter_name, monsters])
			var result : CombatSimResults = results[poi_name][encounter_data.encounter_name]
			texts.append("\t\t%.1f%%\t\t\t%.1f" % [ result.get_win_percentage(), result.get_average_character_deaths()])
	results_text.text = '\n'.join(texts)

func _on_button_pressed() -> void:
	test_encounters()
