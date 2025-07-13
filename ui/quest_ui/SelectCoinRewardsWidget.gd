extends HBoxContainer

@export var item_value_label : Label 

@onready var select_minimum_coins_button: Button = %SelectMinimumCoinsButton
@onready var select_fewer_coins_button: Button = %SelectFewerCoinsButton
@onready var select_more_coins_button: Button = %SelectMoreCoinsButton
@onready var select_maximum_coins_button: Button = %SelectMaximumCoinsButton

@onready var selected_coins_label: Label = %SelectedCoinsLabel
@onready var item_rewards: ItemContainer = %ItemRewards
@onready var quest_loot: ItemContainer = %QuestLoot

var debt := 4
var party_coins := 5
var selected := 0
var item_value := 0

func _ready():
	select_minimum_coins_button.pressed.connect(select_minimum)
	select_fewer_coins_button.pressed.connect(select_fewer)
	select_more_coins_button.pressed.connect(select_more)
	select_maximum_coins_button.pressed.connect(select_maximum)
	
	item_rewards.item_added.connect(on_item_reward_chosen)
	quest_loot.item_added.connect(on_item_reward_unchosen)
	
	initialise(debt, party_coins)

func initialise(_debt : int, _party_coins : int):
	debt = _debt
	party_coins = _party_coins
	set_item_value(0)
	
	select_maximum()

func update_enabled_buttons():
	select_minimum_coins_button.disabled = selected <= 0
	select_maximum_coins_button.disabled = selected >= min(debt - item_value, party_coins)
	select_fewer_coins_button.disabled =  selected <= 0
	select_more_coins_button.disabled = selected >= min(debt - item_value, party_coins)

func select_minimum():
	set_selected(0)

func select_fewer(amount := 1):
	set_selected(selected - amount)

func select_more(amount := 1):
	set_selected(selected + amount)

func select_maximum():
	set_selected(min(debt - item_value, party_coins))

func set_selected(_selected):
	selected = _selected
	update_enabled_buttons()
	
	var selected_text = str(selected)
	if selected >= 0:
		selected_text = "+" + selected_text 
	selected_coins_label.text = selected_text

func set_item_value(_item_value):
	item_value = _item_value
	update_enabled_buttons()
	select_maximum()
	
	var item_value_text = str(item_value)
	if item_value >= 0:
		item_value_text = "+" + item_value_text 
	item_value_label.text = item_value_text

func on_item_reward_chosen(item : Item):
	if not is_instance_valid(item):
		push_error("Invalid item chosen for reward")
		return
	set_item_value(item_value + item.get_value())

func on_item_reward_unchosen(item : Item):
	if not is_instance_valid(item):
		push_error("Invalid item unchosen for reward")
		return
	set_item_value(item_value - item.get_value())
