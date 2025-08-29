extends Node

func fade_in(node: CanvasItem, duration: float):
	if not node: return
	node.modulate.a = 0
	node.visible = true
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration)

# Fade Out
func fade_out(node: CanvasItem, duration: float, hide_after := true):
	if not node: return
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration)
	if hide_after:
		tween.tween_callback(func(): node.visible = false)
