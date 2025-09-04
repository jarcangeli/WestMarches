extends Resource
class_name EncounterData

@export var encounter_name : String

@export var description : String

#TODO: Should these be PackedStringArrays
@export var monster_names : Array[String] = []
@export var item_names : Array[String] = []

@export var repeatable := false

@export var on_start_message : String
@export var on_combat_start_message : String
@export var on_win_message : String
@export var on_lose_message : String
