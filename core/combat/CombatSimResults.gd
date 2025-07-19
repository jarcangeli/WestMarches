extends RefCounted
class_name ComatSimResults

var wins : int = 0
var losses : int = 0

func get_win_percentage() -> float:
	return wins / float(wins + losses) * 100.0

func get_run_count() -> int:
	return wins + losses
