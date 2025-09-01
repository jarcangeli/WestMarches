extends VBoxContainer

@export var player_inventory : PlayerInventory
@export var item_popup_scene : PackedScene
@export var player_currencies : PlayerCurrencies

@onready var gold_popup: Control = %GoldPopup
@onready var gold_popup_amount_label: Label = %GoldPopupAmountLabel
@onready var gold_popup_timer: Timer = %GoldPopupTimer

#TODO: Throttle popups appearing and limit to max

@onready var label: Label = $Label

const MAX_POPUPS := 3
var popups_queue = []
const POPUP_QUEUE_TIMER := 1.0

func _ready():
	child_entered_tree.connect(on_children_changed, CONNECT_DEFERRED)
	child_exiting_tree.connect(on_children_changed, CONNECT_DEFERRED)
	player_inventory.item_added.connect(on_player_item_gained)
	player_currencies.gold_added.connect(on_player_gold_gained)
	gold_popup_timer.timeout.connect(on_gold_popup_timer_timeout)
	gold_popup.gui_input.connect(on_gold_popup_input_even)
	gold_popup.visible = false
	gold_popup_amount_label.text = "0"
	on_children_changed(null)
	
	var popup_queue_timer = Timer.new()
	add_child(popup_queue_timer)
	popup_queue_timer.wait_time = POPUP_QUEUE_TIMER
	popup_queue_timer.timeout.connect(popup_queue_check)
	popup_queue_timer.start()

func popup_queue_check():
	if popups_queue.is_empty() or get_current_popups().size() >= MAX_POPUPS:
		return
	var item = popups_queue[0]
	popups_queue.remove_at(0)
	on_player_item_gained(item)
	popup_queue_check()

func on_children_changed(_child):
	label.visible = get_child_count() > 3

func on_player_item_gained(item : Item):
	if get_current_popups().size() >= MAX_POPUPS:
		popups_queue.append(item)
		return
	var popup = item_popup_scene.instantiate()
	popup.popup_closed.connect(on_popup_force_closed)
	add_child(popup)
	popup.set_item(item)

func get_current_popups():
	var popups = []
	for node in get_children():
		if node is ItemPopup:
			popups.append(node)
	return popups

func on_popup_force_closed():
	popups_queue.clear()
	for node in get_current_popups():
		node.queue_free()

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
