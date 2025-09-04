extends Button


func _on_pressed() -> void:
	AudioPlayer.play_sfx(preload("res://audio/click.ogg"))
	get_parent().hide()
