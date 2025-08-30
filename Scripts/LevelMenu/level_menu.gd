extends Control

@onready var level_buttons: Array = get_children().filter(func(c): return c is LevelButton)

func _ready() -> void:
	MusicPlayer.play_music(preload("res://audio/MenuGame.ogg"))
	GlobalProgress.load_progress()
	level_buttons.sort_custom(func(a: LevelButton, b: LevelButton) -> bool:
		return a.level_index < b.level_index
	)

	for i in range(level_buttons.size()):
		if level_buttons[i].level_index <= GlobalProgress.unlocked_level:
			level_buttons[i].disabled = false
			level_buttons[i].modulate = Color(1, 1, 1, 1)
		else:
			level_buttons[i].disabled = true
			level_buttons[i].modulate = Color(1, 1, 1, 0.7)
