extends Node
# [TODO] Class where things that need tuning go
# when it's tuned, move it to an appropriate location

const DEBUG := false

const TUTORIAL := false

const ENABLE_ITEM_ICON_TWEEN := true

const QUEST_MIN_PERCENT = 10
const QUEST_MAX_PERCENT = 99
const QUEST_MAX_ITERATIONS = 10
const QUEST_MAX_ITERATIONS_DEBUG = 10
const QUEST_TRAVEL_ITEM_CHANCE = 0

func quest_max_iterations():
	if DEBUG:
		return QUEST_MAX_ITERATIONS_DEBUG
	else:
		return QUEST_MAX_ITERATIONS

const UNCOMMON_VALUE = 7
const RARE_VALUE = 13
const EPIC_VALUE = 22

const RARE_CHANCE = 0.05
const EPIC_CHANCE = 0.12
const UNCOMMON_CHANCE = 0.30
#const COMMON_CHANCE = 0.53

const MAX_CHARACTER_LEVEL = 5
const GLOBAL_UNLOCKED_SLOTS := [ Item.Slot.WEAPON ]
const SLOT_UNLOCK_ORDER_BY_CLASS := {
	Character.CharacterClass.NONE:
		[ Item.Slot.WEAPON, Item.Slot.CHEST, Item.Slot.HEAD, Item.Slot.LEGS, Item.Slot.FEET,
		Item.Slot.POTION, Item.Slot.RANGED, Item.Slot.BELT, Item.Slot.RING, Item.Slot.CAPE],
	Character.CharacterClass.BRAWLER:
		[ Item.Slot.CHEST, Item.Slot.HEAD, Item.Slot.LEGS, Item.Slot.POTION, Item.Slot.RANGED ],
	Character.CharacterClass.RANGER:
		[ Item.Slot.RANGED, Item.Slot.FEET, Item.Slot.LEGS, Item.Slot.BELT, Item.Slot.CAPE],
	Character.CharacterClass.THIEF:
		[ Item.Slot.CAPE, Item.Slot.POTION, Item.Slot.RING, Item.Slot.FEET, Item.Slot.LEGS  ],
	Character.CharacterClass.CHAMPION:
		[  Item.Slot.HEAD, Item.Slot.BELT, Item.Slot.CAPE, Item.Slot.RING, Item.Slot.CHEST  ]
	}

func experience_from_monster(monster : Character) -> int:
	return monster.get_power_level()

func experience_from_monsters(monsters : Array[Character]) -> int:
	var experience := 0;
	for monster in monsters:
		if not monster.is_alive():
			experience += experience_from_monster(monster)
	return experience

func level_from_experience(experience) -> int:
	return min(1 + floor(experience / float(40)), MAX_CHARACTER_LEVEL)
