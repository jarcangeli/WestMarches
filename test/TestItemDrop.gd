extends HBoxContainer


@onready var inventory_1_display: ItemDisplayContainer = %Inventory1Display
@onready var inventory_1: ItemContainer = %Inventory1
@onready var inventory_2_display: ItemDisplayContainer = %Inventory2Display
@onready var inventory_2: ItemContainer = %Inventory2

func _ready():
	inventory_1_display.add_items(inventory_1.get_items())
	inventory_2_display.add_items(inventory_2.get_items())
