extends Button

@export var level_index: int = 3

func _on_pressed() -> void:
	if not disabled:
		SfxPlayer.play_music(preload("res://audio/click.ogg"))
		MusicPlayer.stop_music()
		get_tree().change_scene_to_file("res://Level/Lvl3/Game.tscn" % level_index)
