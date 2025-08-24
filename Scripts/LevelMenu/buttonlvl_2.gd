extends Button

@export var level_index: int = 2
@export var level_scene: String = "res://Level/Lv2/Game.tscn"

func _ready():
	if level_index > GlobalProgress.unlocked_level:
		disabled = true

func _on_pressed() -> void:
	#if not disabled:
	get_tree().change_scene_to_file(level_scene)
