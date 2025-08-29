extends TextureButton

@onready var options: Control = $"../../Options"

func _on_pressed() -> void:
	SfxPlayer.play_music(preload("res://audio/click.ogg"))
	options.visible = true
	get_parent().visible = false
