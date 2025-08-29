extends Button
class_name LevelButton
@export var level_index: int = 1
@onready var level_buttons = get_parent().get_children().filter(func(c): return c is LevelButton)


func _ready() -> void:
	GlobalProgress.load_progress()
	for i in range(level_buttons.size()):
		if i + 1 <= GlobalProgress.unlocked_level:
			level_buttons[i].disabled = false
			print("Apakah level unlock: ", level_buttons[i].disabled)
			
		else:
				level_buttons[i].disabled = true
	
				
func _on_pressed() -> void:
		if not disabled:
			SfxPlayer.play_music(preload("res://audio/click.ogg"))
			MusicPlayer.stop_music()
			get_tree().change_scene_to_file("res://Level/Lv%d/Game.tscn" % level_index)
