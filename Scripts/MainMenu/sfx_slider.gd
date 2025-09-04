extends HSlider

var audio_bus_id: int

func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index("SFX")
	min_value = 0.0
	max_value = 1.0
	step = 0.01
	value = db_to_linear(AudioServer.get_bus_volume_db(audio_bus_id))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(audio_bus_id, linear_to_db(value))
