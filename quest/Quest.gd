extends Node
class_name Quest

export var quest_name : String
export(String, MULTILINE) var quest_description : String

export var target_path : NodePath
onready var target = get_node(target_path)
