extends HSlider

var audio_bus_id: int

func _ready() -> void:
	var bus_name: String = MusicPlayer.get_node("AudioStreamPlayer").bus 
	audio_bus_id = AudioServer.get_bus_index(bus_name)

	value = db_to_linear(AudioServer.get_bus_volume_db(audio_bus_id))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(audio_bus_id, value)
