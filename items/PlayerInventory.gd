extends ItemContainer
class_name PlayerInventory

func _ready():
	Globals.player_inventory = self
	
	if TuningKnobs.DEBUG:
		for item_id in ItemDatabase.data_by_index:
			var item = Item.new(ItemDatabase.get_data_by_index(item_id))
			add_item(item)
	
	item_added.connect(on_item_added, CONNECT_DEFERRED)
	on_item_added.call_deferred(null)

func add_item(item : Item):
	if is_instance_valid(item):
		if item.loaned_character:
			item.loaned_character = null
			#TODO: Properly unequip
	super.add_item(item)

func on_item_added(_item: Item):
	SignalBus.player_inventory_changed.emit()
