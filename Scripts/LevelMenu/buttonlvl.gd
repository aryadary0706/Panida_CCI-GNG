extends Button
class_name LevelButton

@export var level_index: int = 1
@onready var level_image: TextureRect = $TextureRect

func _ready() -> void:
	pass

func _on_pressed() -> void:
	if not disabled:
		SfxPlayer.play_music(preload("res://audio/click.ogg"))
		MusicPlayer.stop_music()
		var level_path = "res://Level/Lv%d/Game.tscn" % level_index
		get_tree().call_deferred("change_scene_to_file", level_path)
