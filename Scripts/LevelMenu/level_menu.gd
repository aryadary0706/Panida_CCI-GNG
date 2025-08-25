extends Control


func _ready() -> void:
	MusicPlayer.play_music(preload("res://audio/MenuGame.ogg"))
