extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	get_tree().paused = false

func _on_back_pressed() -> void:
	SfxPlayer.play_music(preload("res://audio/click.ogg"))
	get_tree().call_deferred("change_scene_to_file", "res://Objects/LevelMenu/level_menu.tscn")

func play_scene():
	show()
	MusicPlayer.play_music(preload("res://audio/LevelComplete.ogg"))
	GlobalProgress.unlock_next_level()
