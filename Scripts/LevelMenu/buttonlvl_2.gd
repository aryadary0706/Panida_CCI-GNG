extends Button

@export var level_index: int = 2

func _on_pressed() -> void:
	if not disabled:
		SfxPlayer.play_music(preload("res://audio/click.ogg"))
		MusicPlayer.stop_music()
		get_tree().change_scene_to_file("res://Level/Lvl2/Game.tscn" % level_index)
