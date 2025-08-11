extends Control

@export var parties : Node
@export var results_container : TabContainer

@onready var sheet_scene = preload("res://test/TestPartyBalanceSheet.tscn")

const iterations = 100

func _on_button_pressed() -> void:
	for node in results_container.get_children():
		if node is TestPartyBalanceSheet:
			node.queue_free()
	
	# Run  sims
	var start = Time.get_ticks_msec()
	
	var i := 0
	for party : AdventuringParty in parties.get_children():
		i += 1
		var sheet = sheet_scene.instantiate()
		results_container.add_child(sheet)
		sheet.test_encounters(party, iterations)
		results_container.set_tab_title(i, party.display_name)

	
	var end = Time.get_ticks_msec()
	print("Total simulations completed in %d msecs" % (end - start))
