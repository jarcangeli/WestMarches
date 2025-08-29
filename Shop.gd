extends Control
class_name Shop

@export var shop_inventory : ItemContainer

@onready var player_items: ItemDisplayContainer = %PlayerItems
@onready var sell_items: ItemDisplayContainer = %SellItems
@onready var buy_items: ItemDisplayContainer = %BuyItems
@onready var shop_items: ItemDisplayContainer = %ShopItems

@onready var trade_button: Button = %TradeButton
@onready var trade_amount_label: Label = %TradeAmountLabel
@onready var sell_amount_label: Label = %SellAmountLabel
@onready var buy_amount_label: Label = %BuyAmountLabel

func _ready() -> void:
	shop_items.set_item_container(shop_inventory)
	
	player_items.item_selected.connect(on_player_item_selected)
	shop_items.item_selected.connect(on_shop_item_selected)
	sell_items.item_selected.connect(on_sell_item_selected)
	buy_items.item_selected.connect(on_buy_item_selected)
	trade_button.pressed.connect(trade_button_pressed)
	
	sell_items.child_entered_tree.connect(update_amount_label, CONNECT_DEFERRED)
	sell_items.child_exiting_tree.connect(update_amount_label, CONNECT_DEFERRED)
	buy_items.child_entered_tree.connect(update_amount_label, CONNECT_DEFERRED)
	buy_items.child_exiting_tree.connect(update_amount_label, CONNECT_DEFERRED)
	update_amount_label()
	
	Globals.shop = self

func trade_button_pressed():
	var sold_items = sell_items.get_displayed_items()
	var bought_items = buy_items.get_displayed_items()
	var gold_to_add := 0
	
	for sold_item in sold_items:
		shop_items.add_item(sold_item)
		gold_to_add += sold_item.get_value()
	sell_items.clear_item_views()
	
	for bought_item in bought_items:
		Globals.player_inventory.add_item(bought_item)
		gold_to_add -= bought_item.get_value()
	buy_items.clear_item_views()
	
	if gold_to_add >= 0:
		Globals.player_currencies.add_gold(gold_to_add)
	else:
		Globals.player_currencies.remove_gold(abs(gold_to_add))

func update_amount_label(_dummy = null):
	var sell_amount := 0
	for item : Item in sell_items.get_displayed_items():
		sell_amount += item.get_value()
	sell_amount_label.text = str(sell_amount)
	
	var buy_amount := 0
	for item : Item in buy_items.get_displayed_items():
		buy_amount += item.get_value()
	buy_amount_label.text = str(buy_amount)
	
	var amount = sell_amount - buy_amount
	trade_amount_label.text = ("+" if amount >= 0 else "") + str(amount)

func sell_item(party : AdventuringParty, item : Item):
	var value = item.get_value()
	shop_items.add_item(item)
	party.gold += value
	print(item.item_name, " sold to shop by ", party.display_name, " for ", str(value))

func on_player_item_selected(item : Item):
	player_items.remove_item_display(item)
	sell_items.add_item(item)

func on_shop_item_selected(item : Item):
	shop_items.remove_item_display(item)
	buy_items.add_item(item)

func on_sell_item_selected(item : Item):
	sell_items.remove_item_display(item)
	player_items.add_item(item)

func on_buy_item_selected(item : Item):
	buy_items.remove_item_display(item)
	shop_items.add_item(item)
