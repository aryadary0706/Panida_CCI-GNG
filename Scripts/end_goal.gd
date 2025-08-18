extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.queue_free()
		Global.Health -= body.healthLoss
		print("You have ", Global.Health, " health left")
