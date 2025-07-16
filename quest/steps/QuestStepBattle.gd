extends QuestStep
class_name QuestStepBattle

var monsters : Array
var combat : Combat

var combat_log : Array = []

func initialise(_monsters):
	monsters = _monsters

func advance_step():
	print("Battle started!")
	combat = Combat.new(party.get_characters(), monsters)
	combat.combat_log.connect(on_combat_log_line)
	while (!combat.is_finished()):
		combat.play_round()

func finished():
	if not started:
		return false
	if ( 	not is_instance_valid(party) or 
			not is_instance_valid(quest) ) :
		push_warning("Invalid quest travel step state, terminating early")
		return true
	return combat and combat.is_finished()

func on_combat_log_line(line : String):
	print(line)
	combat_log.append(line)

func get_progress_text():
	return combat_log
