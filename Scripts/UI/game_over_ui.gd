extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
