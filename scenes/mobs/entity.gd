extends CharacterBody2D

@export var speed = 300

var Health = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_parent().progress += speed * delta
	if get_parent().progress_ratio == 1:
		death()
		Game.health -= 5

	if Health <= 0 :
		death()
		Game.money += 5

func death():
	get_parent().get_parent().queue_free()
