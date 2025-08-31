extends Control

@export var icon_spawn_rate := 0.05
@export var fall_speed := 100
@export var  fall_speed_range := 10
@export var  fall_speed_increments := 10
@export var rotation_speed := 10
@export var item_icon_scene : PackedScene

var timer : Timer = null

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = icon_spawn_rate
	timer.timeout.connect(spawn_icon)
	timer.start()
	
	Globals.state_changed.connect(on_game_state_changed)

func on_game_state_changed():
	if Globals.state == Globals.GameState.MENU:
		timer.start()
		process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		timer.stop()
		process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta : float):
	for node in get_children():
		if node is ItemIcon and is_instance_valid(node):
			animate(node, delta)
			
			if node.global_position.y > (size[1] + 64):
				# dropped off the bottom
				node.queue_free()

func animate(icon : ItemIcon, delta : float):
	icon.global_position.y += delta * (fall_speed + fall_speed_range * (icon.item.id % fall_speed_increments) )
	icon.rotation_degrees -= delta * rotation_speed *  (((icon.item.id % 2) * 2) - 1)

func spawn_icon():
	var item := ItemDatabase.generate_random_item()
	var icon : ItemIcon = item_icon_scene.instantiate()
	icon.hover_grow_enabled = false
	add_child(icon)
	icon.set_item(item)
	icon.position.x = randf() * size[0]
	icon.position.y = -64
	
	icon.rotation_degrees = randf() * 45 * (((item.id % 2) * 2) - 1)
