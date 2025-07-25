extends Resource
class_name CharacterData


var id : int = 0
var character_name : String
var stats := AbilityStats.new()

func valid():
	return id and character_name
