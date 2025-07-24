extends Node2D

@export var poi_name : String

const poi_scene := preload("res://map/POI.tscn")

func _ready():
	if poi_name == name:
		name = "[TEMP] " + name
	var poi_data = POIDatabase.pois_by_name.get(poi_name)
	if poi_data:
		var poi = poi_scene.instantiate()
		poi.load_data(poi_data)
		poi.position = position
		get_parent().add_child.call_deferred(poi, true)
		queue_free.call_deferred()
	else:
		push_error("Could not load POI by name: " + poi_name)
