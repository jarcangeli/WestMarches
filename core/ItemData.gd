extends Resource
class_name ItemData

var id : int = 0
var item_name : String
var description : String
var icon : Texture2D
var primary_slot_type : Item.Slot
var consumed_on_acquire : bool
var currency_generated : int
var stat_values : Array[int]
var value : int
var rarity : Globals.Rarity

func valid():
	return id and item_name and description and icon
