extends Button


func _on_pressed() -> void:
	SfxPlayer.play_music(preload("res://audio/click.ogg"))
	get_tree().change_scene_to_file("res://Objects/MainMenu/main_menu.tscn")
