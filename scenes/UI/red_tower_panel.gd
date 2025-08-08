extends Panel

@onready var red_tower_scene = preload("res://scenes/towers/red_missile_tower.tscn")
@onready var main = get_tree().get_root().get_node("Main")

var border_active := StyleBoxFlat.new()
var border_default := StyleBoxFlat.new()

func _ready():
	# Set default border
	border_active.border_width_bottom = 0
	border_active.border_width_top = 0
	border_active.border_width_left = 0
	border_active.border_width_right = 0

	# Set border aktif (misal garis bawah merah)
	border_active.border_width_bottom = 4
	border_active.border_width_top = 4
	border_active.border_width_left = 4
	border_active.border_width_right = 4
	border_active.border_color = Color(50, 0, 0)

	add_theme_stylebox_override("panel", border_default)

func _on_gui_input(event):
	if event.is_action_pressed("left_mouse"):
		main.select_tower(red_tower_scene, self)


func _on_start_wave_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
