extends HBoxContainer

onready var inventory_display_container = $ItemsDisplayContainer
onready var item_detail_view = $ItemDetailView

func _ready():
	SignalBus.hconnect("player_inventory_changed", self, "on_player_inventory_changed")
	
	inventory_display_container.connect("item_selected", self, "on_item_selected")
	
	on_player_inventory_changed()

func on_item_selected(item):
	item_detail_view.set_item(item)

func on_player_inventory_changed():
	inventory_display_container.clear_items()
	if Globals.player_inventory:
		inventory_display_container.load_items(Globals.player_inventory.get_children())
