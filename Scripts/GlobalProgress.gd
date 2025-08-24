extends Node

var unlocked_level: int = 1

func save_progress():
	var save_data = {
		"unlocked_level": unlocked_level
	}
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	file.store_var(save_data)

func load_progress():
	if FileAccess.file_exists("user://savegame.save"):
		var file = FileAccess.open("user://savegame.save", FileAccess.READ)
		var save_data = file.get_var()
		unlocked_level = save_data.get("unlocked_level", 1)
