extends Control

func set_item(item : Item):
	var name = ""
	if is_instance_valid(item):
		name = item.item_name
	$VBoxContainer/ItemNameLabel.text = name
