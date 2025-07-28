extends VBoxContainer

@onready var item_icon: ItemIcon = %ItemIconDisabled
@onready var despawn_timer: Timer = %DespawnTimer
@onready var item_label: Label = %ItemLabel

func set_item(item : Item):
	item_icon.set_item(item)
	item_label.text = item.item_name
	despawn_timer.timeout.connect(on_despawn_timer_timeout)

func on_despawn_timer_timeout():
	#TODO: Animate
	queue_free()
