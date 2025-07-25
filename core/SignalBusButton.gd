extends Button

@export var signal_string : String

func _ready():
	var err = connect("pressed", Callable(self, "on_button_pressed"))
	if err:
		push_error(err)

func on_button_pressed():
	if signal_string.is_empty():
		push_warning("Empty signal string on signal button")
		return

	SignalBus.emit_signal(signal_string)
