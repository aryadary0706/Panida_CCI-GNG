extends Node

var money := 100
var health := 100
var game_over := false

func _process(delta):
	if not game_over and health <= 0:
		game_over = true
		on_game_over()

func on_game_over():
	get_tree().quit()
