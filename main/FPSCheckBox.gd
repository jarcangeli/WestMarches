extends CheckBox

func _ready():
	set_pressed_no_signal(TK.DEBUG)
	toggled.connect(on_toggled)

func on_toggled(toggled : bool):
	SignalBus.show_fps_toggled.emit(toggled)
