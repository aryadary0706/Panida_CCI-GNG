extends HSlider

var audio_bus_id: int

func _ready() -> void:
	var bus_name: String = MusicPlayer.get_node("AudioStreamPlayer").bus 
	audio_bus_id = AudioServer.get_bus_index(bus_name)
	var current_volume_db = AudioServer.get_bus_volume_db(audio_bus_id)
	value = db_to_linear(current_volume_db)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(audio_bus_id, value)
