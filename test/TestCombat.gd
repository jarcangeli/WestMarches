extends Control

@export var adventurer : Character

@onready var combat_log: TextEdit = %CombatLog
@onready var combat_summary: TextEdit = %CombatSummary
@onready var sim_results: TextEdit = %SimResults
@onready var damage_meter: Container = %DamageMeter

func run_single_combat():
	adventurer.equip_best_gear()
	
	combat_log.clear()
	combat_summary.clear()
	var monsters : Array[Character] = []
	for node in get_children():
		if node is Character and node != adventurer:
			monsters.append(node)
	
	var combat = Combat.new([adventurer], monsters)
	combat.combat_log.connect(on_combat_log_line)
	combat.play_through()
	print_summary(combat)
	damage_meter.set_combat_results(combat.combat_summary)

func simulate_combats():
	sim_results.clear()
	
	adventurer.equip_best_gear()
	
	var monsters : Array[Character] = []
	for node in get_children():
		if node is Character and node != adventurer:
			monsters.append(node)
	
	var start = Time.get_ticks_msec()
	var iterations := 3000
	var results := CombatSim.simulate([adventurer], monsters, iterations)
	var end = Time.get_ticks_msec()
	on_sim_result_line("Running simulation")
	on_sim_result_line("Simulation completed in %d msecs" % (end - start))
	on_sim_result_line("\tor %.2f msecs per iteration" % ((end - start)/float(iterations)))
	on_sim_result_line("\tor %d usecs per iteration" % int((end - start)/float(iterations)*1000.))
	on_sim_result_line("Combat sim results %d / %d = %.1f%%" % 
		[results.wins, results.get_run_count(), results.get_win_percentage()])


func on_combat_log_line(line : String):
	combat_log.text = combat_log.text + line + '\n'

func on_sim_result_line(line : String):
	sim_results.text = sim_results.text + line + '\n'

func on_summary_line(line : String):
	combat_summary.text = combat_summary.text + line + '\n'

func print_summary(combat : Combat):
	var summary = combat.combat_summary
	for character in summary.keys():
		var character_summary : CharacterCombatSummary = summary[character]
		on_summary_line(character.name)
		on_summary_line(str(character_summary.damage_done))
		on_summary_line(str(character_summary.damage_received))
		on_summary_line(str(character_summary.healing))
		on_summary_line('')


func _on_simulate_combats_button_pressed() -> void:
	simulate_combats()

func _on_run_single_combat_button_pressed() -> void:
	run_single_combat()
