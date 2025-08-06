extends Node

const pitch_range = 0.1

func _ready():
	var _err = AudioBus.play.connect(on_play_requested)
	
	setup_button_audio()

func on_play_requested(stream):
	for player in get_children():
		if not player is AudioStreamPlayer or \
		   player.playing:
			continue
		
		player.stream = stream
		player.pitch_scale = 1 - (pitch_range/2.0 - randf()*pitch_range)
		player.play()
		return
	push_warning("Could not play audio as all stream players were playing")

func setup_button_audio():
	var buttons = get_tree().get_nodes_in_group("button")
	for button in buttons:
		button.pressed.connect(on_button_pressed)

func on_button_pressed():
	on_play_requested(AudioBus.button_press)
