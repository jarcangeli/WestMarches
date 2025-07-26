extends Control
class_name StatsDisplay

@export var show_empty := true
@export var font_size := 14
@export var icon_size := 8

@onready var container : GridContainer = $StatsGrid

var stat_display_scene = preload("res://core/StatDisplay.tscn")

func set_stats(values : Array[int]):
	clear_displays()
	
	for type in range(0, AbilityStats.Type.SIZE):
		var value = values[type]
		if not show_empty and value == 0:
			continue
		if type == AbilityStats.Type.CRIT_RATE and value == 1:
			continue
		if type == AbilityStats.Type.POISON_DAMAGE and value == 1:
			continue
		var stat_display = stat_display_scene.instantiate()
		container.add_child(stat_display)
		stat_display.set_stat.call_deferred(type, value)
		stat_display.set_sizes.call_deferred(font_size, icon_size)

func clear_displays():
	for node in container.get_children():
		node.queue_free()
