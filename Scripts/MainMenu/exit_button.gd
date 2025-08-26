extends TextureButton

func _on_pressed() -> void:
	SfxPlayer.play_music(preload("res://audio/click.ogg"))
	get_tree().quit()
