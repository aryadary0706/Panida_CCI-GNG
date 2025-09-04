extends Control
@onready var options: Control = $Options
@onready var sign_post: Control = $SignPost

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music(preload("res://audio/MenuGame.ogg"), true)
	sign_post.visible = true
	options.visible = false



func _on_back_pressed() -> void:
	AudioPlayer.play_sfx(preload("res://audio/click.ogg"))
	sign_post.visible = true
	options.visible = false
	
