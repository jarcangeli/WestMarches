extends RefCounted
class_name CombatSimResults

var wins : int = 0
var losses : int = 0
var character_deaths : int = 0

func get_win_percentage() -> float:
	return wins / float(wins + losses) * 100.0

func get_run_count() -> int:
	return wins + losses

func get_average_character_deaths() -> float:
	return character_deaths / float(wins + losses)
