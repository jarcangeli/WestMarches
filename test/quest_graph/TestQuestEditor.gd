extends MarginContainer

@export var quest_node_scene : PackedScene
@export var poi_node_scene : PackedScene
@export var save_path : String

@onready var graph_edit: GraphEdit = %GraphEdit

const save_file 			= "quest_graph.tscn"
const backup_file 			= "backup_quest_graph.tscn"

const save_folder = "graph_data/"
const backup_folder = "backup_graph_data/"

func _ready():
	var parent = graph_edit.get_parent()
	graph_edit.queue_free()
	var scene = ResourceLoader.load(save_path + save_file)
	graph_edit = scene.instantiate()
	parent.add_child(graph_edit, true)
	connect_graph_edit()
	for node in graph_edit.get_children():
		if node is QuestEncounterNode or node is QuestPOINode:
			node.set_owner(graph_edit)
	load_data_files_to_nodes()

func connect_graph_edit():
	if not graph_edit:
		push_error("Trying to connect null grap_edit")
		return
	graph_edit.right_disconnects = true
	graph_edit.connection_request.connect(graph_connect)
	graph_edit.disconnection_request.connect(graph_disconnect)

func graph_connect(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	graph_edit.connect_node(from_node, from_port, to_node, to_port)

func graph_disconnect(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)

func store_connected_nodes_recursive(node_name, connections, node_save_order, data_file):
	for connection in connections:
		if connection["from_node"] == node_name:
			var to_node = connection["to_node"]
			node_save_order.append(to_node)
			store_encounter_node(graph_edit.find_child(to_node), data_file)
			store_connected_nodes_recursive(to_node, connections, node_save_order, data_file)
			#TODO: Prevent recursion

func _on_save_button_pressed() -> void:
	# Store a backup of last open data
	#var dir = DirAccess.open(save_path)
	#var err = 0
	#dir.remove(backup_folder)
	#if dir.dir_exists(save_folder):
		#err = dir.rename(save_folder, backup_folder)
		#if err:
			#push_error(err)
			#return
	
	var node_save_order = []
	var connections = graph_edit.connections
	for poi_node in graph_edit.get_children():
		if poi_node is QuestPOINode:
			var poi_data := (poi_node as QuestPOINode).get_poi_data()
			var file_name = save_path + save_folder + "%s.cfg" % poi_node.name
			var data_file := FileAccess.open(file_name, FileAccess.WRITE)
			var err = FileAccess.get_open_error()
			if err or not data_file:
				push_error(err)
				
			data_file.store_string("[%s]\n" % poi_node.name)
			data_file.store_string("name=\"%s\"\n" % poi_data.poi_name)
			data_file.store_string("description=\"%s\"\n" % poi_data.description)
			data_file.store_string('\n')
			node_save_order.append(poi_node.name)
			
			store_connected_nodes_recursive(poi_node.name, connections, node_save_order, data_file)
			data_file.close()
	
	# Handle orphaned nodes (editor only)
	var orphan_data_file := FileAccess.open(save_path + save_folder + "orphaned.cfg", FileAccess.WRITE)
	var o_err = FileAccess.get_open_error()
	if o_err or not orphan_data_file:
		push_error(o_err)
	for node in graph_edit.get_children():
		if node is QuestEncounterNode and not node.name in node_save_order:
			store_encounter_node(node as QuestEncounterNode, orphan_data_file)
	orphan_data_file.close()
	
	# Store a backup of last open scene
	#dir.remove(backup_file)
	#if dir.file_exists(save_file):
		#err = dir.rename(save_file, backup_file)
		#if err:
			#push_error(err)
			#return
	
	# Save scene to file
	var scene = PackedScene.new()
	scene.pack(graph_edit)
	ResourceSaver.save(scene, save_path + save_file)

func store_encounter_node(node : QuestEncounterNode, data_file : FileAccess):
		var encounter_data := node.get_encounter_data()
		data_file.store_string("[%s]\n" % node.name)
		data_file.store_string("name=\"%s\"\n" % encounter_data.encounter_name)
		data_file.store_string("description=\"%s\"\n" % encounter_data.description)
		data_file.store_string("repeatable=%s\n" % ("true" if encounter_data.repeatable else "false"))
		for i in range(len(encounter_data.monster_names)):
			var monster_name = encounter_data.monster_names[i]
			data_file.store_string("monster%d=\"%s\"\n" % [i+1, monster_name])
		for i in range(len(encounter_data.item_names)):
			var item_name = encounter_data.item_names[i]
			data_file.store_string("item%d=\"%s\"\n" % [i+1, item_name])
		data_file.store_string('\n')

func load_data_files_to_nodes():
	var dir = DirAccess.open(save_path + save_folder)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		load_data_file_to_nodes(file_name)
		file_name = dir.get_next()

func load_data_file_to_nodes(file_name):
	var config = ConfigFile.new()
	var err = config.load(save_path + save_folder + file_name)
	if err:
		push_error(err)
		return
	
	for section in config.get_sections():
		var node = graph_edit.find_child(section)
		if not node:
			continue
		if node is QuestEncounterNode:
			node.set_slot(0, true, 0, Color(1,1,1), true, 0, Color(0,1,0))
			var encounter_data := POIDatabaseClass.get_encounter_data_from_cfg_section(config, section)
			node.set_encounter_data(encounter_data)
		if node is QuestPOINode:
			node.set_slot(0, true, 0, Color(1,1,1), true, 0, Color(0,1,0))
			var poi_data := POIDatabaseClass.get_poi_data_from_cfg_section(config, section)
			node.set_poi_data(poi_data)

func _on_add_quest_button_pressed() -> void:
	var node : QuestEncounterNode = quest_node_scene.instantiate()
	graph_edit.add_child(node, true)
	node.set_owner(graph_edit)

func _on_add_poi_button_pressed() -> void:
	var node : QuestPOINode = poi_node_scene.instantiate()
	graph_edit.add_child(node, true)
	node.set_owner(graph_edit)

func _on_delete_quest_button_pressed() -> void:
	for node in graph_edit.get_children():
		if node is QuestEncounterNode and node.selected:
			node.queue_free()
