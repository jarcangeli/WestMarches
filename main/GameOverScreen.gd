extends Container

@onready var return_to_game_button: AudioButton = %ReturnToGameButton
@onready var game_over_label: Label = %GameOverLabel

func _ready():
	visible = false
	return_to_game_button.pressed.connect(on_return_to_game_button_pressed)

func on_return_to_game_button_pressed():
	visible = false

func set_party_loss():
	game_over_label.text = "All adventurers have been defeated.\nEvil still resides beyond the western marches."

func set_financial_loss():
	game_over_label.text = "You have run out of gold and items.\nThe adventurers will have to go on without you.\nEvil still resides beyond the western marches."
