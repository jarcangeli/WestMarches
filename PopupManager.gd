extends Control

@export var player_inventory : PlayerInventory
@export var item_popup_scene : PackedScene
@export var player_currencies : PlayerCurrencies

@onready var gold_popup: Control = %GoldPopup
@onready var gold_popup_amount_label: Label = %GoldPopupAmountLabel
@onready var gold_popup_timer: Timer = %GoldPopupTimer

#TODO: Throttle popups appearing and limit to max

@onready var label: Label = $Label

func _ready():
	child_entered_tree.connect(on_children_changed, CONNECT_DEFERRED)
	child_exiting_tree.connect(on_children_changed, CONNECT_DEFERRED)
	player_inventory.item_added.connect(on_player_item_gained)
	player_currencies.gold_added.connect(on_player_item_gained)
	gold_popup_timer.timeout.connect(on_gold_popup_timer_timeout)
	gold_popup.gui_input.connect(on_gold_popup_input_even)
	gold_popup.visible = false
	gold_popup_amount_label.text = "0"
	on_children_changed(null)

func on_children_changed(_child):
	label.visible = get_child_count() > 2

func on_player_item_gained(item : Item):
	var popup = item_popup_scene.instantiate()
	add_child(popup)
	popup.set_item(item)

func on_player_gold_gained(amount : int):
	var current_amount = int(gold_popup_amount_label.text)
	gold_popup_amount_label.text = "+%d" % (current_amount + amount)
	gold_popup_timer.start()
	gold_popup.visible = true

func on_gold_popup_timer_timeout():
	hide_gold_popup()

func on_gold_popup_input_even(event : InputEvent):
	if event is InputEventMouseButton:
		hide_gold_popup()

func hide_gold_popup():
	gold_popup.visible = false
	gold_popup_amount_label.text = "0"
