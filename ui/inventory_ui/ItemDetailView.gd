extends Control

func set_item(item : Item):
	var item_name = ""
	var item_detail = ""
	if is_instance_valid(item):
		item_name = item.item_name
		item_detail = item.description
	$VBoxContainer/ItemNameLabel.text = item_name
	$VBoxContainer/DetailLabel.text = item_detail
