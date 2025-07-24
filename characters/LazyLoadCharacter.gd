extends Node
class_name LazyLoadCharacter

@export var monster_name : String

func _ready():
	if monster_name == name:
		name = "[TEMP] " + name
	run(monster_name, get_parent())
	queue_free.call_deferred()

static func run(_name, parent):
	var monster_data : CharacterData = MonsterDatabase.monster_data_by_name[_name]
	if monster_data:
		var monster = Character.new(monster_data)
		parent.add_child.call_deferred(monster, true)
	else:
		push_error("Could not load monster by name: " + _name)
