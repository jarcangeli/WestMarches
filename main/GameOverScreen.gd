extends Container

@onready var return_to_game_button: AudioButton = %ReturnToGameButton

func _ready():
	visible = false
	return_to_game_button.pressed.connect(on_return_to_game_button_pressed)

func on_return_to_game_button_pressed():
	visible = false
