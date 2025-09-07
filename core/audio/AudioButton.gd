extends Button
class_name AudioButton

func _ready():
	pressed.connect(on_audio_button_pressed)

func on_audio_button_pressed():
	AudioBus.play.emit(AudioBus.button_press)
