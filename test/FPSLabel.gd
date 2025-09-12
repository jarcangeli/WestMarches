extends Label

func _ready():
	visible = TK.DEBUG
	SignalBus.show_fps_toggled.connect(on_show_fps_toggled)

func _process(delta):
	if delta == 0:
		text = "FPS: -"
	else:
		text = "FPS: " + str(int(Engine.get_frames_per_second()))

func on_show_fps_toggled(toggled):
	visible = toggled
