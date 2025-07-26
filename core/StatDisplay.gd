extends HBoxContainer
class_name StatDisplay

#TODO: Scale with container

@onready var stat_icon: TextureRect = %StatIcon
@onready var stat_border: TextureRect = %StatBorder
@onready var stat_label: Label = %StatLabel

func set_stat(type : AbilityStats.Type, value : int):
	stat_icon.texture = AbilityStats.get_icon(type)
	stat_label.text = str(value)
	
	var colour = AbilityStats.colours[type]
	stat_icon.modulate = colour
	stat_border.modulate = colour
	#stat_label.modulate = colour
	
	var stat_name = AbilityStats.names[type]
	tooltip_text = "%s: %d" % [stat_name, value]

func set_sizes(font_size : int, icon_size : int):
	stat_label.add_theme_font_size_override("size", font_size)
	stat_icon.custom_minimum_size = Vector2(icon_size, icon_size)
