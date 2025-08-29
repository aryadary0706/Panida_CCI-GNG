extends Control

@onready var sign_post: Control = $SignPost
@onready var option: Control = $Option

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.play_music(preload("res://audio/MenuGame.ogg"))
	sign_post.visible = true
	option.visible = false




func _on_back_pressed() -> void:
	_ready()
