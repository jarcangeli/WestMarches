extends Label

func _process(delta):
	if delta == 0:
		text = "FPS: -"
	else:
		text = "FPS: " + str(int(Engine.get_frames_per_second()))
