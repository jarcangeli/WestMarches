extends Node

@export var monster_name : String

func _ready():
	var monster_data : CharacterData = MonsterDatabase.monster_data_by_name[monster_name]
	if monster_data:
		var monster = Character.new(monster_data)
		get_parent().add_child.call_deferred(monster)
		queue_free.call_deferred()
	else:
		push_error("Could not load monster by name: " + monster_name)
