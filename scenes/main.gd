extends Node

var selected_tower_scene: PackedScene = null
var is_placing_tower := false
var current_selected_button: Panel = null

func _ready():
	var start_wave_panel = $UI/startWave
	start_wave_panel.wave_started.connect(_on_wave_started)

func _on_wave_started(wave_data: Array):
	$PathSpawn.start_wave(wave_data)

func finish_placing_tower():
	is_placing_tower = false
	selected_tower_scene = null
	if current_selected_button:
		current_selected_button.add_theme_stylebox_override("panel", current_selected_button.border_default)
		current_selected_button = null


func select_tower(scene: PackedScene, button_node: Panel):
	selected_tower_scene = scene
	is_placing_tower = true

	if current_selected_button != null:
		current_selected_button.add_theme_stylebox_override("panel", current_selected_button.border_default)

	button_node.add_theme_stylebox_override("panel", button_node.border_active)

	current_selected_button = button_node
