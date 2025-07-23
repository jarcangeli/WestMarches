extends Node

var player_inventory : ItemContainer = null
var player_currencies : PlayerCurrencies = null
var character_graveyard : CharacterGraveyard = null

enum Rarity {
	COMMON		= 0,
	UNCOMMON	= 1,
	RARE		= 2,
	EPIC		= 3
}
