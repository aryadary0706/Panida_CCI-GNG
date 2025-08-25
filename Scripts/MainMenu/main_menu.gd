extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.play_music(preload("res://audio/MenuGame.ogg"))
