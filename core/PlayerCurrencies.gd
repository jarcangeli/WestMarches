extends Currencies
class_name PlayerCurrencies

func _ready():
	Globals.player_currencies = self
	
	var err = connect("changed", Callable(self, "on_changed"))
	if err:
		push_error(err)

func on_changed():
	SignalBus.player_currencies_changed.emit()
