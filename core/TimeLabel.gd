extends Label

func _ready():
	SignalBus.time_advanced.connect(self.update_ui)
	update_ui()

func update_ui():
	text = "Day " + str(Globals.day)
