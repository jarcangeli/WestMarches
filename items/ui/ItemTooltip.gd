extends PanelContainer
class_name ItemTooltip

@onready var stats_display: StatsDisplay = %StatsDisplay

func set_item(item : Item):
	var item_name = ""
	var item_detail = ""
	stats_display.set_stats([])
	if item and is_instance_valid(item):
		item_name = item.item_name + (" (loaned)" if item.loaned_character else "")
		item_detail = item.description
		stats_display.set_stats(item.stats.values)
	%ItemNameLabel.text = item_name
	%DetailLabel.text = item_detail
	
	var style_box = get_theme_stylebox("panel")
	style_box.set('bg_color', Globals.rarity_colours[item.rarity])
