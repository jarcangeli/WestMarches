extends HBoxContainer

signal quest_chosen(quest)

export var quest_button_scene : Resource

export var pending_container_path : NodePath
export var new_container_path : NodePath
export var active_container_path : NodePath
export var completed_container_path : NodePath

onready var pending_container = get_node(pending_container_path)
onready var new_container = get_node(new_container_path)
onready var active_container = get_node(active_container_path)
onready var completed_container = get_node(completed_container_path)

onready var quest_info_panel = $QuestInfoPanel
onready var quest_reward_panel = $QuestRewardPanel

var selected_quest : Quest = null

func _ready():
	update_quest_panels()

func initialise():
	visible = true

func clear_button_container(container):
	for node in container.get_children():
		if node is QuestButton:
			node.queue_free()

func add_buttons_to_container(quests, container, disabled=false):
	for quest in quests:
		var quest_button = quest_button_scene.instance()
		quest_button.quest = quest
		quest_button.disabled = disabled
		container.add_child(quest_button)
		var err = quest_button.connect("quest_selected", self, "select_quest")
		if err:
			push_error(err)

func set_pending_quests(quests):
	clear_button_container(pending_container)
	add_buttons_to_container(quests, pending_container)

func set_new_quests(quests):
	clear_button_container(new_container)
	add_buttons_to_container(quests, new_container)

func set_active_quests(quests):
	clear_button_container(active_container)
	add_buttons_to_container(quests, active_container, true)

func set_completed_quests(quests):
	clear_button_container(completed_container)
	add_buttons_to_container(quests, completed_container, true)

func select_quest(quest):
	# Deselect other quests
	for button in new_container.get_children():
		if button is QuestButton and button.quest != quest:
			button.pressed = false
	# Preview info
	selected_quest = quest
	update_quest_panels()

func update_quest_panels():
	quest_info_panel.visible = false
	quest_reward_panel.visible = false
	if not is_instance_valid(selected_quest):
		return
	
	if not selected_quest.started:
		quest_info_panel.visible = true
		quest_info_panel.set_quest(selected_quest)
	elif selected_quest.finished and not selected_quest.completed:
		quest_reward_panel.visible = true
		quest_reward_panel.set_quest(selected_quest)

func on_choose_quest_button_pressed():
	if not is_instance_valid(selected_quest):
		return
	emit_signal("quest_chosen", selected_quest)
	select_quest(null)

func on_collect_rewards_button_pressed():
	if not is_instance_valid(selected_quest):
		return
	selected_quest.complete()
	select_quest(null)
