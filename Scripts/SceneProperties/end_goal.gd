extends Node2D

@onready var wave_manager = get_parent().get_node("WaveManager")

func _ready() -> void:
	wave_manager.connect("game_ended", Callable(self, "game_over"))
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		AudioPlayer.play_sfx(preload("res://audio/Damage.ogg"))
		body.queue_free()
		Global.Health -= body.healthLoss
		print("You have ", Global.Health, " health left")
		if Global.Health <= 0:
			game_over()	
			

func game_over() -> void:
	Engine.time_scale = 0.0  
	get_parent().get_node("Popup/game_over").show()
	AudioPlayer.play_sfx(preload("res://audio/LevelFailed.ogg"))
	print("GAME OVER")
