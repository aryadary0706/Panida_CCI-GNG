extends Node

var selected_tower_scene: PackedScene = null
var is_placing_tower := false
var current_selected_button: Panel = null

func select_tower(scene: PackedScene, button_node: Panel):
	selected_tower_scene = scene
	is_placing_tower = true

	# Reset style tombol sebelumnya
	if selected_tower_scene == null and is_placing_tower: #Error disini
		current_selected_button.add_theme_stylebox_override("panel", current_selected_button.border_active)
	else:
		# Set style aktif
		button_node.add_theme_stylebox_override("panel", button_node.border_default)

	current_selected_button = button_node
