extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	get_tree().paused = false

func _on_back_pressed() -> void:
	AudioPlayer.play_sfx(preload("res://audio/click.ogg"))
	get_tree().call_deferred("change_scene_to_file", "res://Objects/MainMenu/main_menu.tscn")

func play_scene():
	show()
	AudioPlayer.play_music(preload("res://audio/LevelComplete.ogg"), false)
	GlobalProgress.unlock_next_level()
