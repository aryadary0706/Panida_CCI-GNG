extends Node


func fade_in(node: CanvasItem, duration: float = 3) -> void:
	if not node:
		return
	node.modulate.a = 0.0
	node.show()
	var tween := create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration)

func fade_out(node: CanvasItem, duration: float = 3) -> void:
	if not node:
		return
	var tween := create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration)
	node.hide()
	
