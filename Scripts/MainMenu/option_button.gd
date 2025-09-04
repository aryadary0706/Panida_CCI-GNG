extends TextureButton

@onready var options: Control = $"../../Options"

func _on_pressed() -> void:
	AudioPlayer.play_sfx(preload("res://audio/click.ogg"))
	options.visible = true
	get_parent().visible = false
