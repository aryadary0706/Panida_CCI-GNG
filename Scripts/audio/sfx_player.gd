extends Node
@onready var sfx_audio: AudioStreamPlayer = $AudioStreamPlayer

func play_music(stream: AudioStream):
	sfx_audio.stop()
	sfx_audio.stream = stream
	sfx_audio.play()
