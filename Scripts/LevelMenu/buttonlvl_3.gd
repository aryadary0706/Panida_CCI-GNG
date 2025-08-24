extends Button

@export var level_index: int = 3

func _ready():
	if level_index > GlobalProgress.unlocked_level:
		disabled = true

func _on_pressed() -> void:
	#if not disabled:
	get_tree().change_scene_to_file("res://Level/Lv3/Game.tscn")
