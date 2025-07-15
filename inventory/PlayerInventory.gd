extends ItemContainer

func _ready():
	Globals.player_inventory = self
	
	item_added.connect(on_item_added, CONNECT_DEFERRED)

func add_item(item : Item):
	if is_instance_valid(item):
		if item.loaned_character:
			item.loaned_character = null
		if item.equip_slot:
			item.equip_slot = null
	super.add_item(item)

func on_item_added(_item: Item):
	SignalBus.player_inventory_changed.emit()
