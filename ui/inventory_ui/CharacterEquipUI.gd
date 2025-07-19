extends VBoxContainer

var character : Character = null

func set_character(new_character):
	if new_character == null:
		return
	character = new_character
	$CharacterLabel.text = character.character_name
	name = character.character_name
	
	# update base item view (previouisly equipped)
	var containers = get_equipment_containers()
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
