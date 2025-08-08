extends Panel
signal wave_started(wave_data: Array)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var wave_data = []
		for i in range(25):
			wave_data.append({ "type": "enemy_basic" })
		emit_signal("wave_started", wave_data)
