extends Node
# [TODO] Class where things that need tuning go
# when it's tuned, move it to an appropriate location

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
