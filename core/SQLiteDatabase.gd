extends Node

var database_path = "res://database/database.db"

var db = SQLite.new()

func _ready():
	db.path = database_path
	db.verbosity_level = SQLite.VerbosityLevel.NORMAL
	db.read_only = true
	if not db.open_db():
		push_error("Could not open sqlite database")

func query(query_string):
	var success = db.query(query_string)
	if not success:
		return null
	
	return db.get_query_result()

func get_table(table_name):
	return query("SELECT * FROM " + table_name)
