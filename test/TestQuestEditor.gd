extends MarginContainer

@export var quest_node_scene : PackedScene
@export var save_path : String

@onready var graph_edit: GraphEdit = %GraphEdit

const save_file = "quest_graph.tscn"
const data_save_file = "quest_graph.cfg"
const backup_file = "backup_quest_graph.tscn"
const backup_data_save_file = "backup_quest_graph.cfg"

func _ready():
	var parent = graph_edit.get_parent()
	graph_edit.queue_free()
	var scene = ResourceLoader.load(save_path + save_file)
	graph_edit = scene.instantiate()
	parent.add_child(graph_edit)
	for node in graph_edit.get_children():
		if node is QuestEncounterNode:
			node.set_owner(graph_edit)
	load_data_file_to_nodes()

func _on_add_quest_button_pressed() -> void:
	var node : QuestEncounterNode = quest_node_scene.instantiate()
	graph_edit.add_child(node)
	node.update_owners(node, graph_edit)

func _on_save_button_pressed() -> void:
	# Store a backup of last open data
	var dir = DirAccess.open(save_path)
	var err = 0
	dir.remove(backup_data_save_file)
	if dir.file_exists(data_save_file):
		err = dir.rename(data_save_file, backup_data_save_file)
		if err:
			push_error(err)
			return
	
	# Save quests to data file
	var data_file = FileAccess.open(save_path + data_save_file, FileAccess.WRITE)
	err = FileAccess.get_open_error()
	if err or not data_file:
		push_error(err)
		err = 0
	for node in graph_edit.get_children():
		if node is QuestEncounterNode:
			var encounter_data = node.get_encounter_data()
			data_file.store_string("[%s]\n" % node.name)
			data_file.store_string("name=\"%s\"\n" % encounter_data.encounter_name)
			data_file.store_string("description=\"%s\"\n" % encounter_data.description)
			data_file.store_string("repeatable=%s\n" % "true" if encounter_data.repeatable else "false")
			for i in range(len(encounter_data.monster_names)):
				var monster_name = encounter_data.monster_names[i]
				data_file.store_string("monster%d=\"%s\"\n" % [i, monster_name])
			for i in range(len(encounter_data.item_names)):
				var item_name = encounter_data.item_names[i]
				data_file.store_string("item%d=\"%s\"\n" % [i, item_name])
			data_file.store_string('\n')
	data_file.close()
	
	# Store a backup of last open scene
	dir.remove(backup_file)
	if dir.file_exists(save_file):
		err = dir.rename(save_file, backup_file)
		if err:
			push_error(err)
			return
	
	# Save scene to file
	var scene = PackedScene.new()
	scene.pack(graph_edit)
	ResourceSaver.save(scene, save_path + save_file)

func _on_delete_quest_button_pressed() -> void:
	for node in graph_edit.get_children():
		if node is QuestEncounterNode and node.selected:
			node.queue_free()

func load_data_file_to_nodes():
	var config = ConfigFile.new()
	var err = config.load(save_path + data_save_file)
	if err:
		push_error(err)
		return
	
	for node in graph_edit.get_children():
		if node is QuestEncounterNode:
			var encounter_data := POIDatabaseClass.get_encounter_data_from_cfg_section(config, node.name)
			node.set_encounter_data(encounter_data)
