extends Control

@onready var stats_display: Control = %StatsDisplay

func set_item(item : Item):
	var item_name = ""
	var item_detail = ""
	if is_instance_valid(item):
		item_name = item.item_name
		item_detail = item.description
		stats_display.set_stats(item.stats.values)
	%ItemNameLabel.text = item_name
	%DetailLabel.text = item_detail
