extends Container
class_name PartyQuestUI

@export var quest_select_panel_container : Container

@onready var quest_status_ui: Container = %QuestStatusUI
@onready var quest_equip_ui: QuestEquipUI = %QuestEquipUI
@onready var quest_info_panel: PanelContainer = %QuestInfoPanel
@onready var quest_reward_panel: QuestRewardPanel = %QuestRewardPanel

# Quest Progress Info
@onready var combat_container: VBoxContainer = %CombatContainer
@onready var quest_story: TextEdit = %QuestStory
@onready var combat_summary: ScrollContainer = %CombatSummary
@onready var quest_combat_log: TextEdit = %QuestCombatLog
@onready var quest_status_label: Label = %QuestStatusLabel

var party : AdventuringParty = null
var current_quest : Quest = null

func _ready():
	show_quest_select_ui()
	for node in quest_select_panel_container.get_children():
		if node is QuestSelectPanel:
			node.quest_chosen.connect(show_quest_equip_ui)
	
	quest_equip_ui.quest_abandoned.connect(show_quest_select_ui)
	quest_equip_ui.quest_started.connect(on_quest_started)
	
	SignalBus.quest_finished.connect(on_quest_finished)
	quest_reward_panel.quest_completed.connect(on_quest_completed)

func advance_time():
	update_quest_progress_info()

func show_quest_status_ui():
	quest_status_ui.visible = true
	quest_equip_ui.visible = false
	for node in quest_select_panel_container.get_children():
		if node is QuestSelectPanel:
			if node.quest != current_quest:
				node.visible = false
			else:
				node.toggle_running_quest(true)
				node.visible = true
		else:
			node.visible = true

func show_quest_select_ui():
	quest_status_ui.visible = true
	quest_equip_ui.visible = false
	for node in quest_select_panel_container.get_children():
		if node is QuestSelectPanel:
			node.toggle_running_quest(false)
			node.visible = true
		else:
			node.visible = false

func show_quest_equip_ui(quest : Quest):
	quest_status_ui.visible = false
	quest_equip_ui.visible = true
	assert(quest.party == party, "Somehow selected a quest not for this party")
	quest_equip_ui.on_quest_selected(quest)

func on_quest_started(quest : Quest):
	current_quest = quest
	quest_reward_panel.hide_rewards()
	update_quest_progress_info()
	show_quest_status_ui()

func update_quest_progress_info():
	if not current_quest:
		quest_story.text = ""
		quest_combat_log.text = ""
		combat_summary.set_combat(null)
		quest_status_label.text = "???"
		return
	quest_story.text = current_quest.get_progess_text()
	quest_combat_log.text = current_quest.get_combat_log()
	combat_summary.set_combat(current_quest.get_combat())
	combat_container.visible = current_quest.battle_step.combat != null
	
	if current_quest.completed:
		quest_status_label.text = "<completed>"
	elif current_quest.finished:
		quest_status_label.text = "<finished>"
	elif current_quest.started:
		if quest_status_label.text in ["<started>", "<in progress>"]:
			quest_status_label.text = "<in progress>"
		else:
			quest_status_label.text = "<started>"
	else:
		quest_status_label.text = "<unknown>"

func on_quest_finished(quest : Quest):
	if quest != current_quest:
		return
	show_quest_status_ui()
	quest_reward_panel.show_rewards(quest)

func set_party(new_party : AdventuringParty):
	if party == new_party:
		return
	
	party = new_party
	update_tab_title()
	generate_quests()

func generate_quests():
	for node in quest_select_panel_container.get_children():
		if node is QuestSelectPanel:
			var quest = generate_quest()
			node.set_party(party)
			node.set_quest(quest)

func generate_quest() -> Quest:
	if not Globals.quest_manager:
		return null
	return Globals.quest_manager.generate_quest(party)

func update_tab_title():
	var tab_parent = get_parent() as TabContainer
	if tab_parent:
		var i = tab_parent.get_tab_idx_from_control(self)
		if i >= 0:
			var tab_title = party.display_name if party else "Party %d" % (i+1)
			tab_title = "  %s  " % tab_title
			tab_parent.set_tab_title(i, tab_title)

func on_quest_completed(_quest : Quest):
	if not party.is_alive():
		queue_free()
	generate_quests()
	show_quest_select_ui()
