extends Control

@export var icon_spawn_rate := 0.1
@export var fall_speed := 100
@export var item_icon_scene : PackedScene

var timer : Timer = null

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = icon_spawn_rate
	timer.timeout.connect(spawn_icon)
	timer.start()

func _process(delta : float):
	for node in get_children():
		if node is ItemIcon and is_instance_valid(node):
			animate(node, delta)
			
			if node.global_position.y > size[1]:
				# dropped off the bottom
				node.queue_free()

func animate(icon : ItemIcon, delta : float):
	icon.global_position.y += delta * fall_speed

func spawn_icon():
	var item := ItemDatabase.generate_random_item()
	var icon : ItemIcon = item_icon_scene.instantiate()
	add_child(icon)
	icon.set_item(item)
	icon.position.x = randf() * size[0]
