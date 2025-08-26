extends TextureButton

func _on_pressed() -> void:
	SfxPlayer.play_music(preload("res://audio/click.ogg"))
	get_tree().change_scene_to_file("res://Objects/LevelMenu/level_menu.tscn")
