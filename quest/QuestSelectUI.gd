extends HBoxContainer

signal quest_chosen(quest)

export var quest_button_scene : Resource
export var container_path : NodePath
onready var container = get_node(container_path)

onready var quest_info_panel = $QuestInfoPanel

func _ready():
	quest_info_panel.connect("quest_chosen", self, "on_quest_chosen")

func initialise():
	visible = true
	quest_info_panel.initialise()

func set_quests(quests):
	for node in container.get_children():
		if node is QuestButton:
			node.queue_free()
	
	for quest in quests:
		var quest_button = quest_button_scene.instance()
		quest_button.quest = quest
		container.add_child(quest_button)
		var err = quest_button.connect("quest_selected", self, "select_quest")
		if err:
			push_error(err)

func select_quest(quest):
	# Deselect other quests
	for button in container.get_children():
		if button is QuestButton and button.quest != quest:
			button.pressed = false
	# Preview info
	quest_info_panel.set_quest(quest)

func on_quest_chosen(quest):
	emit_signal("quest_chosen", quest)
