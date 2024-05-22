extends Button

signal quest_selected(quest)

export var quest_node_path : NodePath
onready var quest = get_node(quest_node_path)

func _ready():
	connect("pressed", self, "on_pressed")

func on_pressed():
	emit_signal("quest_selected", quest)
