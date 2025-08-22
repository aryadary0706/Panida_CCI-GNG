extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func _on_back_pressed() -> void:
	get_tree().quit()
