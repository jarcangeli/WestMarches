extends Label

func _ready():
	SignalBus.player_currencies_changed.connect(self.on_player_currencies_changed)
	update_ui()

func on_player_currencies_changed():
	update_ui()

func update_ui():
	if is_instance_valid(Globals.player_currencies):
		text = Globals.player_currencies.print_to_string()
	else:
		text = "-"
