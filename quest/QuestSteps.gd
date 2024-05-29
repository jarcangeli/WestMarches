extends Node

var active = false

var active_step = null
var time_in_step = 0

func get_first_step():
	return get_child(0)

func advance_time():
	if not active:
		return
	if active_step == null:
		active_step = get_first_step()
		if active_step == null:
			push_error("Could not get active quest step")
	
	time_in_step += 1
	
	active_step.advance_step() # where quest happens
	
	#TODO: Report early failure?
	if time_in_step >= active_step.get_duration():
		SignalBus.emit_signal("quest_completed", get_quest())

func get_quest():
	return get_parent()
