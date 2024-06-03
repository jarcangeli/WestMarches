extends Node

var active_step = null
var step_index = 0

func get_next_step() -> QuestStep:
	return get_child(step_index) as QuestStep

func advance_time(party) -> void:
	if not active():
		return
	if active_step == null:
		active_step = get_next_step()
		if active_step == null:
			push_error("Could not get active quest step")
	
	active_step.advance_step(party) # where quest happens
	
	#TODO: Report early failure?
	if active_step.finished():
		step_index += 1
		if get_child_count() <= step_index:
			var quest : Quest = get_quest()
			quest.finish()
		else:
			active_step = get_next_step()
			active_step.start(get_quest(), get_party())

func get_quest() -> Quest:
	return get_parent() as Quest

func get_party() -> AdventuringParty:
	return get_quest().party

func active() -> bool:
	return get_quest().active()
