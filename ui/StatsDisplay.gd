extends CenterContainer

@onready var container : GridContainer = $StatsGrid

var stat_display_scene = preload("res://ui/StatDisplay.tscn")

func set_stats(values : Array[int]):
	clear_displays()
	
	for type in range(0, AbilityStats.Type.SIZE):
		var stat_display = stat_display_scene.instantiate()
		container.add_child(stat_display)
		stat_display.set_stat.call_deferred(type, values[type])

func clear_displays():
	for node in container.get_children():
		node.queue_free()
