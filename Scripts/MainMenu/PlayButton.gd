extends TextureButton

@onready var level_menu: Control = $"../../LevelMenu"
func _on_pressed() -> void:
	AudioPlayer.play_sfx(preload("res://audio/click.ogg"))
	level_menu.show()
	
