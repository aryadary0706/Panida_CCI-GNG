# res://ui/Pole.gd
extends Control
@export var color := Color8(214, 163, 109) # cokelat kayu
@export var tip_height := 36.0             # tinggi segitiga ujung

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw():
	# batang
	var w := 0.42 * size.x   # lebar batang relatif (di tengah)
	var x := (size.x - w) * 0.5
	draw_rect(Rect2(Vector2(x, tip_height), Vector2(w, size.y - tip_height)), color)
	# ujung segitiga
	var mid := size.x * 0.5
	var half := w * 0.5
	var pts := PackedVector2Array([
		Vector2(mid, 0),
		Vector2(mid - half, tip_height),
		Vector2(mid + half, tip_height),
	])
	draw_colored_polygon(pts, color)

func _size_changed():
	queue_redraw()
