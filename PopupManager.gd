extends Control

@export var player_inventory : PlayerInventory
@export var item_popup_scene : PackedScene

#TODO: Throttle popups appearing and limit to max

@onready var label: Label = $Label

func _ready():
	player_inventory.item_added.connect(on_player_item_gained)

func _process(_delta: float) -> void:
	label.visible = get_child_count() > 1
		
func on_player_item_gained(item : Item):
	var popup = item_popup_scene.instantiate()
	add_child(popup)
	popup.set_item(item)
