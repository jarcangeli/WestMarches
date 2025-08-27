extends Node
# [TODO] Class where things that need tuning go
# when it's tuned, move it to an appropriate location

const DEBUG := true

const ENABLE_ITEM_ICON_TWEEN := true

const QUEST_MIN_PERCENT = 5
const QUEST_MAX_PERCENT = 99
const QUEST_MAX_ITERATIONS = 6
const QUEST_TRAVEL_ITEM_CHANCE = 1

const EPIC_VALUE = 8
const RARE_VALUE = 5
const UNCOMMON_VALUE = 2.5

const RARE_CHANCE = 0.05
const EPIC_CHANCE = 0.12
const UNCOMMON_CHANCE = 0.30
#const COMMON_CHANCE = 0.53

const SLOT_UNLOCK_ORDER_BY_CLASS := {
	Character.CharacterClass.NONE:
		[ Item.Slot.WEAPON, Item.Slot.CHEST, Item.Slot.HEAD, Item.Slot.LEGS, Item.Slot.FEET,
		Item.Slot.POTION, Item.Slot.RANGED, Item.Slot.BELT, Item.Slot.RING, Item.Slot.CAPE],
	Character.CharacterClass.FIGHTER:
		[ Item.Slot.WEAPON, Item.Slot.CHEST, Item.Slot.HEAD, Item.Slot.LEGS, Item.Slot.POTION ],
	Character.CharacterClass.RANGER:
		[ Item.Slot.RANGED, Item.Slot.LEGS, Item.Slot.FEET, Item.Slot.BELT, Item.Slot.WEAPON ],
	Character.CharacterClass.THIEF:
		[ Item.Slot.WEAPON, Item.Slot.POTION, Item.Slot.RING, Item.Slot.FEET, Item.Slot.CAPE  ]
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
	return 1 + floor(experience / float(40))
