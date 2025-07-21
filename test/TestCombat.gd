extends Control

@export var adventurer : Character

@onready var combat_log: TextEdit = %CombatLog

func _on_run_combat_button_pressed():
	combat_log.clear()
	var monsters : Array[Character] = []
	for node in get_children():
		if node is Character and node != adventurer:
			monsters.append(node)
	
	#var combat = Combat.new([adventurer], monsters)
	#combat.combat_log.connect(on_combat_log_line)
	#while (!combat.is_finished()):
		#combat.play_round()
	
	# Now run a sim
	var start = Time.get_ticks_msec()
	var results := CombatSim.simulate([adventurer], monsters, 3000)
	var end = Time.get_ticks_msec()
	on_combat_log_line("-------------------------")
	on_combat_log_line("Running simulation")
	on_combat_log_line("Simulation completed in %d msecs" % (end - start))
	on_combat_log_line("Combat sim results %d / %d = %.1f%%" % [results.wins, results.get_run_count(), results.get_win_percentage()])


func on_combat_log_line(line : String):
	combat_log.text = combat_log.text + '\n' + line
