extends AudioButton

@export var signal_string : String

func _ready():
	super._ready()
	pressed.connect(on_button_pressed)

func on_button_pressed():
	if signal_string.is_empty():
		push_warning("Empty signal string on signal button")
		return

	SignalBus.emit_signal(signal_string)
