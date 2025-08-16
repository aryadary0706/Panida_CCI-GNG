extends Control


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")



func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")



func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
