extends Control
class_name EquipmentSlotLayout

func set_character(character : Character):
	var character_class := character.character_class
	var slot_unlock_order : Array = TK.SLOT_UNLOCK_ORDER_BY_CLASS.get(character_class)
	if not slot_unlock_order:
		slot_unlock_order = TK.SLOT_UNLOCK_ORDER_BY_CLASS.get(Character.CharacterClass.FIGHTER)
	
	var unlocked_slots = []
	var level = character.get_level()
	for i in range(0, level):
		if len(slot_unlock_order) > i:
			unlocked_slots.append(slot_unlock_order[i])
	
	var containers = get_equipment_containers()
	# enable only active slots
	for container in containers:
		var unlockable = slot_unlock_order.has(container.slot)
		var enabled = unlocked_slots.has(container.slot)
		container.set_enabled_unlockable(enabled, unlockable)
		var unlock_level = slot_unlock_order.find(container.slot) + 1
		container.set_unlock_level(unlock_level)
	
	# update base item view (previouisly equipped)
	for item : Item in character.get_equipped_items():
		for container : EquipmentContainer in containers:
			if item.primary_slot_type == container.slot:
				container.set_base_item(item)

func get_equipment_containers(parent = self, containers = []):
	#TODO: Use groups?
	for node in parent.get_children():
		if node is EquipmentContainer:
			containers += [node]
		else:
			containers += get_equipment_containers(node)
	return containers

func get_equipped_items():
	var containers = get_equipment_containers()
	var items = []
	for container in containers:
		if is_instance_valid(container.item):
			items.append(container.item)
	return items

func return_equipped_items():
	var containers = get_equipment_containers()
	for container in containers:
		if is_instance_valid(container.item):
			container.remove_item()
