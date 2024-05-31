extends Node

var active_step = null
var time_in_step = 0

func get_first_step():
	return get_child(0)

func advance_time():
	if not active():
		return
	if active_step == null:
		active_step = get_first_step()
		if active_step == null:
			push_error("Could not get active quest step")
	
	time_in_step += 1
	
	active_step.advance_step() # where quest happens
	
	#TODO: Report early failure?
	if time_in_step >= active_step.get_duration():
		#TODO: Advance next step don't just finish
		var quest = get_quest()
		quest.finish()

func get_quest():
	return get_parent()

func active():
	return get_quest().active()
