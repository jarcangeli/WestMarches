extends PanelContainer
class_name ItemTooltip

@onready var stats_display: StatsDisplay = %StatsDisplay
@onready var value_label: Label = %ValueLabel

@onready var slot_tiny_icon: TextureRect = %SlotTinyIcon
@onready var slot_label: Label = %SlotLabel
@onready var levels_label: Label = %LevelsLabel

func set_item(item : Item):
	var item_name = ""
	var item_detail = ""
	var value := 0
	var slot := Item.Slot.NONE
	stats_display.set_stats([])
	if is_instance_valid(item):
		item_name = item.item_name + (" (loaned)" if item.loaned_character else "")
		item_detail = item.description
		stats_display.set_stats(item.stats.values)
		var style_box = get_theme_stylebox("panel")
		style_box.set('bg_color', Globals.rarity_colours[item.rarity])
		value = item.get_value()
		slot = item.primary_slot_type
	%ItemNameLabel.text = item_name
	%DetailLabel.text = item_detail
	value_label.text = str(value)
	update_slot_info(slot)

func update_slot_info(slot : Item.Slot):
	slot_tiny_icon.texture = Item.slot_tiny_icons[slot]
	slot_label.text = "%s slot" % Item.slot_to_name(slot)
	levels_label.text = ""
	if slot in TK.GLOBAL_UNLOCKED_SLOTS:
		levels_label.text = "all classes"
	else:
		for character in range(1, Character.CharacterClass.SIZE):
			var unlock_order = TK.SLOT_UNLOCK_ORDER_BY_CLASS[character]
			var i = unlock_order.find(slot)
			if i >= 0 and i <= TK.MAX_CHARACTER_LEVEL:
				var character_class_name = Character.character_class_to_string(character)
				levels_label.text += ("" if levels_label.text.is_empty() else "\n") + \
						"%s %d" % [character_class_name, i+1]
