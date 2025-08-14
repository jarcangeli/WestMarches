extends Control
class_name ItemTooltip

@onready var stats_display: StatsDisplay = %StatsDisplay

func set_item(item : Item):
	var item_name = ""
	var item_detail = ""
	stats_display.set_stats([])
	if is_instance_valid(item):
		item_name = item.item_name
		item_detail = item.description
		stats_display.set_stats(item.stats.values)
	%ItemNameLabel.text = item_name
	%DetailLabel.text = item_detail
