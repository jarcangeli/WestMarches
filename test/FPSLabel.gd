extends Label

func _ready():
	visible = TK.DEBUG

func _process(delta):
	if delta == 0:
		text = "FPS: -"
	else:
		text = "FPS: " + str(int(Engine.get_frames_per_second()))
