extends Control
@onready var options: Control = $Options
@onready var sign_post: Control = $SignPost

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.play_loop_music(preload("res://audio/MenuGame.ogg"))
	sign_post.visible = true
	options.visible = false



func _on_back_pressed() -> void:
	SfxPlayer.play_music(preload("res://audio/click.ogg"))
	_ready()
