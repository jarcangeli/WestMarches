extends Node2D

func _process(_delta):
	var mouse_pos = get_mouse_position()
	if mouse_pos:
		transform.origin = mouse_pos

func get_mouse_position():
	var position2D = get_viewport().get_mouse_position()
	return position2D

func get_node_under_cursor():
	pass
