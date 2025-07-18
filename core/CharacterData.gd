extends Resource
class_name CharacterData


var id : int = 0
var character_name : String
var base_constitution : int = 10
var base_strength : int = 10
var base_dexterity : int = 10

func valid():
	return id and character_name
