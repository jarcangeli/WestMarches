extends GraphNode
class_name QuestNoteNode

@onready var title_edit: LineEdit = %TitleEdit
@onready var note_edit: TextEdit = %NoteEdit

func get_note() -> Array[String]:
	var note : Array[String] = []
	note.append(title_edit.text)
	note.append(note_edit.text)
	return note

func set_note(note : Array[String]):
	if note == null or note.size() < 2:
		push_warning("Trying to set note using null or empty")
		return
	title_edit.text = note[0]
	note_edit.text = note[1]
