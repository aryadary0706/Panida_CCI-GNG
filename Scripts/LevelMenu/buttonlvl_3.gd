extends Button

@export var level_index: int = 3
@onready var level_buttons = get_parent().get_children().filter(func(c): return c is Button)

func _on_pressed() -> void:
	GlobalProgress.load_progress()
	for i in range(level_buttons.size()):
		if i + 1 <= GlobalProgress.unlocked_level:
			level_buttons[i].disabled = false
		else:
				level_buttons[i].disabled = true
		if not self.disabled:
			SfxPlayer.play_music(preload("res://audio/click.ogg"))
			MusicPlayer.stop_music()
			get_tree().change_scene_to_file("res://Level/Lv%d/Game.tscn" % level_index)
