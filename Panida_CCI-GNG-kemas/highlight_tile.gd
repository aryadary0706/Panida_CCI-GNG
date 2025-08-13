extends Node2D

func _process(delta: float) -> void:
	follow_mouse_position()

func follow_mouse_position() -> void:
	var mp: Vector2i = get_global_mouse_position() / 64
	position = mp * 64
