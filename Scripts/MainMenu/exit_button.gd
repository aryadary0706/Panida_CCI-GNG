extends TextureButton

func _on_pressed() -> void:
	AudioPlayer.play_sfx(preload("res://audio/click.ogg"))
	get_tree().quit()
