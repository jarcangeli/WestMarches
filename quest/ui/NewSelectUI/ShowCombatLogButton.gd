extends Button

@export var combat_log_container : Container

func _ready():
	reset()
	pressed.connect(show_combat_log)

func reset():
	visible = true
	combat_log_container.visible = false

func show_combat_log():
	combat_log_container.visible = true
	visible = false
