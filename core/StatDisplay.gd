extends HBoxContainer

@onready var stat_icon: TextureRect = %StatIcon
@onready var stat_label: Label = %StatLabel

func set_stat(type : AbilityStats.Type, value : int):
	stat_icon.texture = AbilityStats.get_icon(type)
	stat_label.text = str(value)

func set_sizes(font_size : int, icon_size : int):
	stat_label.add_theme_font_size_override("size", font_size)
	stat_icon.custom_minimum_size = Vector2(icon_size, icon_size)
