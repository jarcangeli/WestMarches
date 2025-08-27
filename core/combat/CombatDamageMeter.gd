extends MarginContainer

@export var container : Container
@export var damage_bar_scene : PackedScene

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
		
		var name_label = Label.new()
		container.add_child(name_label)
		name_label.text = character_name
		
		var damage_bar = damage_bar_scene.instantiate()
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
