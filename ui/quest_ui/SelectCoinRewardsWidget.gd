extends HBoxContainer

@onready var select_minimum_coins_button: Button = %SelectMinimumCoinsButton
@onready var select_fewer_coins_button: Button = %SelectFewerCoinsButton
@onready var select_more_coins_button: Button = %SelectMoreCoinsButton
@onready var select_maximum_coins_button: Button = %SelectMaximumCoinsButton

@onready var selected_coins_label: Label = %SelectedCoinsLabel

var debt := 4
var party_coins := 5
var selected := 0

func _ready():
	select_minimum_coins_button.pressed.connect(select_minimum)
	select_fewer_coins_button.pressed.connect(select_fewer)
	select_more_coins_button.pressed.connect(select_more)
	select_maximum_coins_button.pressed.connect(select_maximum)
	
	initialise(debt, party_coins)

func initialise(_debt : int, _party_coins : int):
	_debt = debt
	_party_coins = party_coins
	
	select_maximum()

func update_enabled_buttons():
	select_minimum_coins_button.disabled = selected <= 0
	select_maximum_coins_button.disabled = selected >= min(debt, party_coins)
	select_fewer_coins_button.disabled =  selected <= 0
	select_more_coins_button.disabled = selected >= min(debt, party_coins)

func select_minimum():
	set_selected(0)

func select_fewer(amount := 1):
	set_selected(selected - amount)

func select_more(amount := 1):
	set_selected(selected + amount)

func select_maximum():
	set_selected(min(debt, party_coins))

func set_selected(_selected):
	selected = _selected
	update_enabled_buttons()
	
	var selected_text = str(selected)
	if selected >= 0:
		selected_text = "+" + selected_text 
	selected_coins_label.text = selected_text
