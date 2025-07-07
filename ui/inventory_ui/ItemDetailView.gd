extends Control

func set_item(item : Item):
	var item_name = ""
	if is_instance_valid(item):
		item_name = item.item_name
	$VBoxContainer/ItemNameLabel.text = item_name
