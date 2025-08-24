extends Button

@export var base_color := Color("76d04b")       # warna dasar
@export var hover_color := Color("8ee66b")      # saat hover
@export var pressed_color := Color("5bb139")    # saat ditekan
@export var arrow_dir := 1                      # 1 = panah kanan, -1 = panah kiri
@export var tip_width := 38.0                   # lebar ujung panah

func _ready():
	flat = true
	focus_mode = FOCUS_NONE
	theme_type_variation = ""

	mouse_entered.connect(func(): queue_redraw())
	mouse_exited.connect(func(): queue_redraw())
	pressed.connect(func(): queue_redraw())
	button_up.connect(func(): queue_redraw())

func _get_color() -> Color:
	if is_pressed(): return pressed_color
	if is_hovered(): return hover_color
	return base_color

func _draw():
	var w := size.x
	var h := size.y
	var t := clampf(tip_width, 10.0, w * 0.45)

	var pts := PackedVector2Array()
	if arrow_dir == 1:
		pts = [Vector2(0,0), Vector2(w - t, 0), Vector2(w, h*0.5),
			   Vector2(w - t, h), Vector2(0, h)]
	else:
		pts = [Vector2(t,0), Vector2(w,0), Vector2(w, h),
			   Vector2(t, h), Vector2(0, h*0.5)]

	draw_colored_polygon(pts, _get_color())

	# outline
	var outline = PackedVector2Array(pts)
	outline.append(pts[0])
	draw_polyline(outline, Color(0,0,0,0.35), 3.0)
	
	var fnt := get_theme_default_font()
	if fnt:
		var font_size = 60
		var text_size = fnt.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
		var pos = Vector2(
			(w - text_size.x) * 0.5,
			(h - text_size.y) * 0.5 + fnt.get_ascent(font_size)
		)
		draw_string(fnt, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.WHITE)
	
	

func _size_changed():
	queue_redraw()


func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Objects/LevelMenu/level_menu.tscn")
