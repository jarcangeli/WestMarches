extends Control

@export var adventurer : Character
@export var monster : Character

@onready var combat_log: TextEdit = %CombatLog

func _ready():
	var combat = Combat.new([adventurer], [monster])
	combat.combat_log.connect(on_combat_log_line)
	while (!combat.is_finished()):
		combat.play_round()

func on_combat_log_line(line : String):
	combat_log.text = combat_log.text + '\n' + line
