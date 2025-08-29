extends Node

var unlocked_level: int = 1

func unlock_next_level():
	unlocked_level += 1
	save_progress()

func save_progress():
	var save = FileAccess.open("user://save.dat", FileAccess.WRITE)
	save.store_var(unlocked_level)
	save.close()

func load_progress():
	if FileAccess.file_exists("user://save.dat"):
		var save = FileAccess.open("user://save.dat", FileAccess.READ)
		unlocked_level = save.get_var()
		save.close()
