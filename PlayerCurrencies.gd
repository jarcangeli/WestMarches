extends Currencies
class_name PlayerCurrencies

func _ready():
	Globals.player_currencies = self
	
	var err = connect("changed", self, "on_changed")
	if err:
		push_error(err)

func on_changed():
	SignalBus.emit_signal("player_currencies_changed")
