extends MarginContainer

# TODO: Hook up with character graveyard node

@export var container : Container

func _ready():
	SignalBus.character_died.connect(on_character_died)

func on_character_died(character : Character):
	if not character:
		return
	var label = Label.new()
	label.text = character.character_name
	container.add_child(label)
