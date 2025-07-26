extends MarginContainer

# TODO: Hook up with character graveyard node

@export var container : Container

var tab_container : TabContainer = null
var tab_index = -1

func _ready():
	SignalBus.character_died.connect(on_character_died)
	
	tab_container = get_parent()
	tab_index = tab_container.get_tab_idx_from_control(self)
	tab_container.set_tab_hidden(tab_index, true)

func on_character_died(character : Character):
	if not character:
		return
	tab_container.set_tab_hidden(tab_index, false)
	var label = Label.new()
	label.text = character.character_name
	container.add_child(label)
