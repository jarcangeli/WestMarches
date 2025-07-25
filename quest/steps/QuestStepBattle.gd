extends QuestStep
class_name QuestStepBattle

var encounter : Encounter
var combat : Combat

var combat_log : Array = []
var combat_story : Array = []

func initialise(_encounter : Encounter):
	encounter = _encounter

func advance_step():
	print("Battle started!")
	combat = Combat.new(party.get_characters(), encounter.get_monsters())
	combat.combat_log.connect(on_combat_log_line)
	combat.combat_story.connect(on_combat_story_line)
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
	combat_log.append(line)

func on_combat_story_line(line : String):
	combat_story.append(line)

func get_combat_log():
	return combat_log

func get_progress_text():
	return combat_story
