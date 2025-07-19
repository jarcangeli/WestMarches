extends Control

@export var adventurer : Character
@export var monster : Character

@onready var combat_log: TextEdit = %CombatLog

func _on_run_combat_button_pressed():
	var combat = Combat.new([adventurer], [monster])
	combat.combat_log.connect(on_combat_log_line)
	while (!combat.is_finished()):
		combat.play_round()
	
	# Now run a sim
	var start = Time.get_ticks_msec()
	var results := CombatSim.simulate([adventurer], [monster], 3000)
	var end = Time.get_ticks_msec()
	on_combat_log_line("-------------------------")
	on_combat_log_line("Running simulation")
	on_combat_log_line("Simulation completed in %d msecs" % (end - start))
	on_combat_log_line("Combat sim results %d / %d = %.1f%%" % [results.wins, results.get_run_count(), results.get_win_percentage()])


func on_combat_log_line(line : String):
	combat_log.text = combat_log.text + '\n' + line
