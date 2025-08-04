class_name HighlightTile
extends Node2D

func _process(delta: float) -> void:
	follow_mouse_position()

func follow_mouse_position() -> void:
	var mp : Vector2i = get_global_mouse_position() / 65
	
	
	position = mp * 64
	print(position)
