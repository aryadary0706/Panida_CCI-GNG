extends Button
class_name LevelButton

@export var level_index: int = 1
@onready var level_image: TextureRect = $TextureRect

func _ready() -> void:
	if disabled:
		level_image.visible = false
	else:
		level_image.visible = true

func _on_pressed() -> void:
	if not disabled:
		SfxPlayer.play_music(preload("res://audio/click.ogg"))
		MusicPlayer.stop_music()
		get_tree().change_scene_to_file("res://Level/Lv%d/Game.tscn" % level_index)
