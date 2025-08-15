extends Node

var game : Control = null
var player_inventory : ItemContainer = null
var player_currencies : PlayerCurrencies = null
var character_graveyard : CharacterGraveyard = null
var shop : Shop = null

enum Rarity {
	COMMON		= 0,
	UNCOMMON	= 1,
	RARE		= 2,
	EPIC		= 3
}

const rarity_colours_old = [
	Color.DIM_GRAY,
	Color.MEDIUM_SEA_GREEN,
	Color.ROYAL_BLUE,
	Color.MEDIUM_PURPLE
]

const background_colour_1 = Color('#363732')
const background_colour_2 = Color('#4A4B44')
const slot_colour = Color('#BAACBD')

const rarity_colours = [
	Color('#944BBB'),
	Color('#558B6E'),
	Color('#35A7FF'),
	Color('#944BBB')
]
