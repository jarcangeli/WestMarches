extends Container

@export var inventory_display_container : Container
@export var item_detail_view : Control = null
@export var detailed_item_icon: ItemIcon

@onready var inventory_side_panel = get_node_or_null("%InventorySidePanel")

func _ready():
	SignalBus.player_inventory_changed.connect(self.on_player_inventory_changed, CONNECT_DEFERRED)
	
	inventory_display_container.connect("item_selected", Callable(self, "on_item_selected"))
	if inventory_side_panel:
		inventory_side_panel.visible = false
	
	on_player_inventory_changed()
	
	if TK.TUTORIAL and get_parent() is TabContainer:
		var tab_container : TabContainer = get_parent()
		SignalBus.quest_started.connect(on_first_quest_started, CONNECT_ONE_SHOT)
		var tab_index = tab_container.get_tab_idx_from_control(self)
		tab_container.set_tab_hidden(tab_index, true)
		tab_container.get_tab_bar().visible = false

func on_first_quest_started(_quest):
	var tab_container : TabContainer = get_parent()
	var tab_index = tab_container.get_tab_idx_from_control(self)
	tab_container.set_tab_hidden(tab_index, false)
	tab_container.get_tab_bar().visible = true

func on_item_selected(item):
	if inventory_side_panel:
		inventory_side_panel.visible = true
	if item_detail_view:
		item_detail_view.set_item(item)
	if detailed_item_icon:
		detailed_item_icon.set_item(item)
		detailed_item_icon.randomize_background_texture()

func on_player_inventory_changed():
	inventory_display_container.clear_item_views()
	if Globals.player_inventory:
		inventory_display_container.add_items(Globals.player_inventory.get_children())
