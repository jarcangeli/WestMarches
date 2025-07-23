extends Node
# [TODO] Class where things that need tuning go
# when it's tuned, move it to an appropriate location

const QUEST_MIN_PERCENT = 0
const QUEST_MAX_PERCENT = 100
const QUEST_MAX_ITERATIONS = 20

const SLOT_UNLOCK_ORDER_BY_CLASS := {
	Character.CharacterClass.NONE:
		[ Item.Slot.WEAPON, Item.Slot.CHEST, Item.Slot.HEAD, Item.Slot.LEGS, Item.Slot.FEET,
		Item.Slot.POTION, Item.Slot.RANGED, Item.Slot.BELT, Item.Slot.RING, Item.Slot.CAPE],
	Character.CharacterClass.FIGHTER:
		[ Item.Slot.WEAPON, Item.Slot.CHEST, Item.Slot.HEAD, Item.Slot.LEGS, Item.Slot.POTION ],
	Character.CharacterClass.RANGER:
		[ Item.Slot.RANGED, Item.Slot.LEGS, Item.Slot.FEET, Item.Slot.BELT, Item.Slot.WEAPON ],
	Character.CharacterClass.THIEF:
		[ Item.Slot.WEAPON, Item.Slot.POTION, Item.Slot.RING, Item.Slot.FEET, Item.Slot.CAPE,  ]
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
