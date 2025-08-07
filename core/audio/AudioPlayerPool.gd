extends Node

func _ready():
	var _err = AudioBus.play.connect(on_play_requested)
	
	setup_button_audio()

func on_play_requested(stream):
	var least_remaining_time = -1
	var interrupt_player = null
	for player in get_children():
		if not player is AudioStreamPlayer:
			continue
		if player.playing:
			var played_time = player.get_playback_position()
			var total_time = player.stream.get_length()
			var remaining_time = total_time - played_time
			if remaining_time < least_remaining_time or least_remaining_time == -1:
				least_remaining_time = remaining_time
				interrupt_player = player
			continue
		play(stream, player)
		return
	if not interrupt_player:
		push_error("Could not play audio as couldn't find audio stream player")
	play(stream, interrupt_player)

func play(stream, player, pitch_range = 0.1, pitch_off = 0.0):
	player.stream = stream
	player.pitch_scale = 1 - (pitch_range/2.0 - randf()*pitch_range) - pitch_off
	player.play()

func setup_button_audio():
	var buttons = get_tree().get_nodes_in_group("button")
	for button in buttons:
		button.pressed.connect(on_button_pressed)

func on_button_pressed():
	on_play_requested(AudioBus.button_press)
