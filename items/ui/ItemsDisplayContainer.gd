extends ItemDropArea
class_name ItemDisplayContainer

signal item_selected(item)

@export var select_enabled := true
@export var item_display_scene_path : Resource = preload("res://items/ui/ItemIconDisabled.tscn")
@export var item_container : ItemContainer = null #if no item container set, acts as a view on other containers

func _ready():
	set_item_container(item_container)
	super._ready()

func set_item_container(container : ItemContainer):
	item_container = container
	if item_container:
		item_container.item_added.connect(add_item_display)
		for item in item_container.get_items():
			add_item_display(item)

func clear_item_views():
	for node in get_children():
		if node is ItemIcon:
			remove_child(node)
			node.queue_free()

func on_item_selected(item):
	if not select_enabled:
		return
	item_selected.emit(item)
	for node in get_children():
		if node.has_method("get_item") and node.get_item() != item and node.has_method("set_selected"):
			node.set_selected(false)

func add_items(items):
	for item in items:
		if not item is Item:
			continue
		add_item(item)

func add_item(item : Item):
	if item_container:
		item_container.add_item(item)
	else:
		add_item_display(item)

func add_item_display(item):
	var display = item_display_scene_path.instantiate()
	display.select_enabled = select_enabled
	add_child(display)
	display.set_item(item)
	
	display.connect("item_selected", Callable(self, "on_item_selected").bind(item)) #ignore errs
	
	var err = connect("item_selected", Callable(display, "on_other_item_selected"))
	if err:
		push_error("Could not hook up item ui deselection: " + err)
	
	err = item.connect("item_changed", Callable(display, "on_item_changed"))
	if err:
		push_error("Could not connect item change to display: " + err)

func remove_item_display(item):
	for child in get_children():
		if child.get_item() == item:
			child.queue_free()
			return

func get_displayed_items():
	var items = []
	for node in get_children():
		if node is ItemIcon:
			var item = node.item
			if item:
				items.append(node.item)
	return items

func get_selected_items():
	var items = []
	for node in get_children():
		if node is ItemIcon and node.selected:
			items.append(node.item)
	return items

func get_unselected_items():
	var items = []
	for node in get_children():
		if node is ItemIcon and not node.selected:
			items.append(node.item)
	return items
