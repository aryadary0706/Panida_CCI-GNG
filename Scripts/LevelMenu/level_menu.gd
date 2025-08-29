extends Control

@onready var level_buttons = [
	get_node("ButtonLvl_1"),
	get_node("ButtonLvl_2"),
	get_node("ButtonLvl_3")
]

func _ready() -> void:
	MusicPlayer.play_music(preload("res://audio/MenuGame.ogg"))
	#GlobalProgress.load_progress()
	#for i in range(level_buttons.size()):
	#	if i + 1 <= GlobalProgress.unlocked_level:
	#		level_buttons[i].disabled = false
	#	else:
	#		level_buttons[i].disabled = true
