extends HBoxContainer

onready var inventory_display_container = $InventoryDisplayContainer
onready var item_detail_view = $ItemDetailView

func _ready():
	inventory_display_container.connect("item_selected", self, "on_item_selected")

func on_item_selected(item):
	item_detail_view.set_item(item)
