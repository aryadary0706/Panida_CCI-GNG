extends CollisionShape2D

func _process(delta: float) -> void:
	show()

func _draw() -> void:
	var center = Vector2(0,0)
	var range =  get_parent().get_parent().range
	var col = Color(0 ,255 ,0 , 0.3)
	draw_circle(center, range, col)
