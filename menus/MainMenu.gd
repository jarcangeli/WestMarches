extends MarginContainer

@export var game_scene : PackedScene

@onready var menu_container: HBoxContainer = %MenuContainer
@onready var settings_menu_ui: VBoxContainer = %SettingsMenuUI
@onready var main_menu_ui: VBoxContainer = %MainMenuUI

@onready var start_button: Button = %StartButton
@onready var resume_button: Button = %ResumeButton

@onready var audio_player_pool: Node = %AudioPlayerPool

func _ready():
	SignalBus.menu_requested.connect(show_main_menu)
	if TK.DEBUG:
		start_game()
	else:
		show_main_menu()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		show_main_menu()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	main_menu_ui.visible = false
	settings_menu_ui.visible = true

func _on_start_button_pressed() -> void:
	start_game()

func start_game():
	var game = game_scene.instantiate()
	add_child(game)
	menu_container.visible = false
	Globals.set_state(Globals.GameState.GAME)

func _on_back_button_pressed() -> void:
	show_main_menu()

func _on_resume_button_pressed() -> void:
	if not Globals.game:
		show_main_menu()
	else:
		menu_container.visible = false
		Globals.game.visible = true
	Globals.set_state(Globals.GameState.GAME)

func show_main_menu():
	Globals.set_state(Globals.GameState.MENU)
	if Globals.game:
		resume_button.visible = true
		Globals.game.visible = false
	else:
		resume_button.visible = false
	
	menu_container.visible = true
	settings_menu_ui.visible = false
	main_menu_ui.visible = true
