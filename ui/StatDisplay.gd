extends HBoxContainer

@onready var stat_icon: TextureRect = %StatIcon
@onready var stat_label: Label = %StatLabel

func set_stat(type : AbilityStats.Type, value : int):
	stat_icon.texture = AbilityStats.get_icon(type)
	stat_label.text = str(value)
