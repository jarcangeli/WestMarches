extends MarginContainer

@export var container : Container
@export var damage_bar_scene : PackedScene

@onready var adventurer_damage_style_box_flat = preload("res://core/combat/adventurer_damage_style_box_flat.tres")
@onready var monster_damage_style_box_flat = preload("res://core/combat/monster_damage_style_box_flat.tres")
@onready var skull_texture = preload("res://assets/icons/skull.png")

func set_combat_results(combat_results : Dictionary):
	for node in container.get_children():
		node.queue_free()
	
	var character_summaries = combat_results.values()
	if character_summaries.is_empty():
		return
	character_summaries.sort_custom(sort_summaries)
	var max_damage = character_summaries[0].total_damage_done()
	
	# Create UI elements
	for summary in character_summaries:
		var character_name = summary.character_name
		var damage = summary.total_damage_done()
		
		var dead_texture_rect = TextureRect.new()
		container.add_child(dead_texture_rect)
		dead_texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		if summary.dead:
			dead_texture_rect.texture = skull_texture
		
		var name_label = Label.new()
		container.add_child(name_label)
		name_label.text = character_name
		
		var damage_bar : ProgressBar = damage_bar_scene.instantiate()
		if summary.adventurer:
			damage_bar.add_theme_stylebox_override("fill", adventurer_damage_style_box_flat)
		else:
			damage_bar.add_theme_stylebox_override("fill", monster_damage_style_box_flat)
		container.add_child(damage_bar)
		damage_bar.max_value = max_damage
		damage_bar.value = damage
		
		var damage_label = Label.new()
		container.add_child(damage_label)
		damage_label.text = str(damage)

func sort_summaries(a, b):
	var dmg_a = a.total_damage_done()
	var dmg_b = b.total_damage_done()
	if dmg_a > dmg_b:
		return true
	return false
