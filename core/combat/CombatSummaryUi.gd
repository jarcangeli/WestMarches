extends Control

@export var character_summary_ui_scene : PackedScene
@export var container : Container

@onready var damage_meter: Container = %DamageMeter

func _ready():
	clear()

func set_combat(combat : Combat):
	clear()
	if not combat:
		return
	damage_meter.set_combat_results(combat.combat_summary)
	for summary in combat.combat_summary.values():
		var summary_ui = character_summary_ui_scene.instantiate()
		container.add_child(summary_ui)
		summary_ui.set_data.call_deferred(summary)

func clear():
	for node in container.get_children():
		node.queue_free()
