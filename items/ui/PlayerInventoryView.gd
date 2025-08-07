extends Container

@export var inventory_display_container : Container
@export var item_detail_view : Control = null

func _ready():
	SignalBus.player_inventory_changed.connect(self.on_player_inventory_changed, CONNECT_DEFERRED)
	
	inventory_display_container.connect("item_selected", Callable(self, "on_item_selected"))
	
	on_player_inventory_changed()

func on_item_selected(item):
	if item_detail_view:
		item_detail_view.set_item(item)

func on_player_inventory_changed():
	inventory_display_container.clear_item_views()
	if Globals.player_inventory:
		inventory_display_container.add_items(Globals.player_inventory.get_children())
