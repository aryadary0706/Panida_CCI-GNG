extends TextureButton

func _on_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/Game.tscn")
	get_parent().visible = false
	get_parent().get_parent().get_node("Option").visible = true
